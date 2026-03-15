# operations for org.XX.egGO
make_sublist = function(x) {
   nr = nrow(x)
   vv = vector("list", nrow(x))
   for (i in seq_len(nr)) 
     vv[[i]] = list(GOID=x$GO_ID[i], Evidence=x$Evidence[i], Ontology=x$ShortCategory[i])
   names(vv) = x$GO_ID
   vv
}

remapCat = function(x) {
  mp = c("Function", "Process", "Component")
  mpt = c("MF", "BP", "CC")
  names(mpt) = mp
  mpt[x]
}

makeGOENV = function(pkgname) {
  ns <- getNamespace(pkgname)
# import the gene2go parquet
  ff = fullread.gene2go()
  ff$ShortCategory = remapCat(ff$Category)

#
# this is somewhat clumsy but works to establish a functional environment
# note that GO2ALLEGS uses the GO hierarchy to add genes mapped to conceptual offspring of term
#
  CURRENT = "org.Hs.egGO"
  CURRENTE = "org.Hs.egGO_env"
# process data.frame
  bygene = split(ff, ff$GeneID)
  genel = lapply(bygene, make_sublist)
  names(genel) = names(bygene)
# start environment production
  assign(CURRENTE, new.env(hash=TRUE), envir=ns)
  nn = lapply(seq_len(length(genel)), 
     function(i) assign(names(genel)[i], genel[[i]], , envir=get(CURRENTE, envir=ns)))
# Now create the active binding
  f = function() {
     class(org.Hs.egGO_env) = c("hsParqEnv", "environment")
     org.Hs.egGO_env
     }
  rm(list=CURRENT, envir=ns)
  makeActiveBinding(CURRENT, f, ns)
}


#' self-describing object for GO interface
#' @export
org.Hs.egGO  <- NULL

makeGO2EGENV = function(pkgname) {
  ns <- getNamespace(pkgname)
# import the gene2go parquet
  ff = fullread.gene2go()
  gg = split(ff, ff$GO_ID)
  hh = lapply(gg, function(x) {ans = x$GeneID; names(ans) = x$Evidence; ans})
#
# this is somewhat clumsy but works to establish a functional environment
# note that GO2ALLEGS uses the GO hierarchy to add genes mapped to conceptual offspring of term
#
  CURRENT = "org.Hs.egGO2EG"
  CURRENTE = "org.Hs.egGO2EG_env"

# start environment production
  assign(CURRENTE, new.env(hash=TRUE), envir=ns)
  nn = lapply(seq_len(length(hh)), 
     function(i) assign(names(hh)[i], as.character(hh[[i]]), , envir=get(CURRENTE, envir=ns)))
# Now create the active binding
  f = function() {
     class(org.Hs.egGO2EG_env) = c("hsParqEnv", "environment")
     org.Hs.egGO2EG_env
     }
  rm(list=CURRENT, envir=ns)
  makeActiveBinding(CURRENT, f, ns)
}


#' self-describing object for GO2EG interface
#' @export
org.Hs.egGO2EG <- NULL

makeALIAS2EGENV = function(pkgname) {
  ns <- getNamespace(pkgname)
# import the gene2accession parquet
  ff = fullread.ncbitxt(stub="gene_info")

#
# this is somewhat clumsy but works to establish a functional environment
# note that GO2ALLEGS uses the GO hierarchy to add genes mapped to conceptual offspring of term
#
  CURRENT = "org.Hs.egALIAS2EG"
  CURRENTE = "org.Hs.egALIAS2EG_env"
# process data.frame
  bygene = strsplit(ff$Synonym, "\\|")
  lens = vapply(bygene, length, numeric(1))
  dat = data.frame(GeneID=as.character(rep(ff$GeneID, lens)), alias=unlist(bygene))
  dat = dat[-which(dat$alias=="-"),]
  byalias = split(dat$GeneID, dat$alias)
# start environment production
  assign(CURRENTE, new.env(hash=TRUE), envir=ns)
  nn = lapply(seq_len(length(byalias)), 
     function(i) assign(names(byalias)[i], byalias[[i]], , envir=get(CURRENTE, envir=ns)))
# Now create the active binding
  f = function() {
     class(org.Hs.egALIAS2EG_env) = c("hsParqEnv", "environment")
     org.Hs.egALIAS2EG_env
     }
  rm(list=CURRENT, envir=ns)
  makeActiveBinding(CURRENT, f, ns)
}

#' self-describing object for ALIAS2EG
#' @export
org.Hs.egALIAS2EG <- NULL

#' closure producer for use in zzz.R
#' @param keys character vector
#' @param values list
#' @param keycolname character of length 1 to be used as the key column name for toTable
#' @param valcolname character of length 1 to be used as the values column name for toTable
#' @export
simpleEnvBuilder = function(keys, values, keycolname, valcolname) {
      force(keys)  # this is crucial to avoid delayed evaluation until active binding is triggered
      force(values)
      force(keycolname)
      force(valcolname)
     function(pkgname, target_env_name = "org.Hs.egENSEMBL") {
  stopifnot(is.character(keys))
  stopifnot(is.list(values))
  CURRENT = target_env_name
  CURE = paste0(target_env_name, "_env")
  ns = getNamespace(pkgname)
  assign(CURE, new.env(hash=TRUE), envir=ns)
  nn = lapply(seq_len(length(keys)), function(i) assign(keys[i], values[[i]], envir=get(CURE, envir=ns)))
  f = function() {
    tmp = get(CURE, envir=ns)
    class(tmp) = c("hsParqEnv", "environment")
    attr(tmp, "keycolname") = keycolname
    attr(tmp, "valcolname") = valcolname
    tmp
    }
  rm(list=CURRENT, envir=ns)
  makeActiveBinding(CURRENT, f, ns)
 }
}

#
# prepare simple map gene->ensembl
#

ff = fullread.ncbitxt(stub="gene2ensembl")
#
# has lots of columns but simple envs need to be based on unique records
#
litff = dplyr::select(ff, Ensembl_gene_identifier, GeneID)
litff = litff |> dplyr::distinct()
bygene = split(litff$Ensembl_gene_identifier, litff$GeneID)
  
makeegENSEMBL = simpleEnvBuilder(keys=names(bygene), values=bygene, keycolname="gene_id", valcolname="ensembl_id")
# now in zzz.R, add makeegENSEMBL(pkgname, "org.Hs.egENSEMBL") in .onLoad

#' self-describing object for ENSEMBL
#' @examples
#' org.Hs.egENSEMBL
#' toTable(org.Hs.egENSEMBL) |> head()
#' @export
org.Hs.egENSEMBL <- NULL

byens = split(litff$GeneID, litff$Ensembl_gene_identifier)
makeegENSEMBL2EG = simpleEnvBuilder(keys=names(byens), values=byens, keycolname="ensembl_id", valcolname="gene_id")

#' self-describing object for ENSEMBL2EG
#' @examples
#' org.Hs.egENSEMBL2EG
#' toTable(org.Hs.egENSEMBL2EG) |> head()
#' @export
org.Hs.egENSEMBL2EG <- NULL

#[15] "org.Hs.egENSEMBL2EG"      "org.Hs.egENSEMBLPROT"
#[17] "org.Hs.egENSEMBLPROT2EG"  "org.Hs.egENSEMBLTRANS"
#[19] "org.Hs.egENSEMBLTRANS2EG"

#> head(ff) |> as.data.frame()
#  #tax_id GeneID Ensembl_gene_identifier RNA_nucleotide_accession.version
#1    9606      1         ENSG00000121410                      NM_130786.4
#2    9606      2         ENSG00000175899                      NM_000014.6
#  Ensembl_rna_identifier protein_accession.version Ensembl_protein_identifier
#1      ENST00000263100.8               NP_570602.2          ENSP00000263100.2
#2     ENST00000318602.12               NP_000005.3          ENSP00000323929.8

### TRANS

litff = dplyr::select(ff, Ensembl_rna_identifier, GeneID) |> dplyr::distinct()

bygene = split(litff$Ensembl_rna_identifier, litff$GeneID)
makeegENSEMBLTRANS = simpleEnvBuilder(keys=names(bygene), values=bygene, keycolname="gene_id", valcolname="trans_id")

#' self-describing object for ENSEMBLTRANS
#' @examples
#' org.Hs.egENSEMBLTRANS
#' toTable(org.Hs.egENSEMBLTRANS) |> head()
#' @export
org.Hs.egENSEMBLTRANS <- NULL

byens = split(litff$GeneID, litff$Ensembl_rna_identifier)
makeegENSEMBLTRANS2EG = simpleEnvBuilder(keys=names(byens), values=byens, keycolname="trans_id", valcolname="gene_id")

#' self-describing object for ENSEMBLTRANS2EG
#' @examples
#' org.Hs.egENSEMBLTRANS2EG
#' toTable(org.Hs.egENSEMBLTRANS2EG) |> head()
#' @export
org.Hs.egENSEMBLTRANS2EG <- NULL

### PROT

litff = dplyr::select(ff, Ensembl_protein_identifier, GeneID) |> dplyr::distinct()

bygene = split(litff$Ensembl_protein_identifier, litff$GeneID)
makeegENSEMBLPROT = simpleEnvBuilder(keys=names(bygene), values=bygene, keycolname="gene_id", valcolname="prot_id")

#' self-describing object for ENSEMBLPROT
#' @examples
#' org.Hs.egENSEMBLPROT
#' toTable(org.Hs.egENSEMBLPROT) |> head()
#' @export
org.Hs.egENSEMBLPROT <- NULL

byens = split(litff$GeneID, litff$Ensembl_protein_identifier)
makeegENSEMBLPROT2EG = simpleEnvBuilder(keys=names(byens), values=byens, keycolname="prot_id", valcolname="gene_id")

#' self-describing object for ENSEMBLPROT2EG
#' @examples
#' org.Hs.egENSEMBLPROT2EG
#' toTable(org.Hs.egENSEMBLPROT2EG) |> head()
#' @export
org.Hs.egENSEMBLPROT2EG <- NULL
