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



#makeALIAS2EGENV = function(pkgname) {
#  ns <- getNamespace(pkgname)
## import the gene2accession parquet
#  ff = fullread.ncbitxt(stub="gene2ensembl")
#
##
## this is somewhat clumsy but works to establish a functional environment
## note that GO2ALLEGS uses the GO hierarchy to add genes mapped to conceptual offspring of term
##
#  CURRENT = "org.Hs.egENSEMBL"
#  CURRENTE = "org.Hs.egENSEMBL_env"
## process data.frame
#  bygene = strsplit(ff$Synonym, "\\|")
#  lens = vapply(bygene, length, numeric(1))
#  dat = data.frame(GeneID=as.character(rep(ff$GeneID, lens)), alias=unlist(bygene))
#  dat = dat[-which(dat$alias=="-"),]
#  byalias = split(dat$GeneID, dat$alias)
## start environment production
#  assign(CURRENTE, new.env(hash=TRUE), envir=ns)
#  nn = lapply(seq_len(length(byalias)), 
#     function(i) assign(names(byalias)[i], byalias[[i]], , envir=get(CURRENTE, envir=ns)))
## Now create the active binding
#  f = function() {
#     class(org.Hs.egALIAS2EG_env) = c("hsParqEnv", "environment")
#     org.Hs.egALIAS2EG_env
#     }
#  rm(list=CURRENT, envir=ns)
#  makeActiveBinding(CURRENT, f, ns)
#}
#
##' self-describing object for ENSEMBL
##' @export
#org.Hs.egENSEMBL <- NULL
#
#EnvBuilder = function(keys, values) function(pkgname, target_env_name = "org.Hs.egENSEMBL") {
#  stopifnot(is.atomic(keys))
#  stopifnot(is.list(values))
#  CURRENT = target_env_name
#  CURE = paste0(target_env_name, "_env")
#  ns = getNamespace(pkgname)
#  assign(CURE, new.env(hash=TRUE), envir=ns)
#  nn = lapply(seq_len(length(keys)), function(i) assign(keys[i], values[[i]], envir=get(CURE, envir=ns)))
#  f = function() {
#    class(get(CURE)) = c("hsParqEnv", "environment")
#    get(CURE)
#    }
#  rm(list=CURRENT, envir=ns)
#  makeActiveBinding(CURRENT, f, ns)
#}
#
#
#  ff = fullread.ncbitxt(stub="gene2ensembl")
#  bygene = strsplit(ff$Synonym, "\\|")
#  lens = vapply(bygene, length, numeric(1))
#  dat = data.frame(GeneID=as.character(rep(ff$GeneID, lens)), alias=unlist(bygene))
#  dat = dat[-which(dat$alias=="-"),]
#  byalias = split(dat$GeneID, dat$alias)
#
#bb = EnvBuilder(names(byalias), byalias)
#


simpleEnvBuilder = function(keys, values, colname) function(pkgname, target_env_name = "org.Hs.egENSEMBL") {
  stopifnot(is.character(keys))
  stopifnot(is.list(values))
  CURRENT = target_env_name
  CURE = paste0(target_env_name, "_env")
  ns = getNamespace(pkgname)
  assign(CURE, new.env(hash=TRUE), envir=ns)
  nn = lapply(seq_len(length(keys)), function(i) assign(keys[i], values[[i]], envir=get(CURE, envir=ns)))
  f = function() {
    tmp = get(CURE)
    class(tmp) = c("hsParqEnv", "environment")
    attr(tmp, "colname") = colname
    tmp
    }
  rm(list=CURRENT, envir=ns)
  makeActiveBinding(CURRENT, f, ns)
}

#
# prepare simple map gene->ensembl
#

ff = fullread.ncbitxt(stub="gene2ensembl")
bygene = split(ff$Ensembl_gene_identifier, ff$GeneID)
  
makeegENSEMBL = simpleEnvBuilder(keys=names(bygene), values=bygene, colname="ensembl_id")

#' self-describing object for ENSEMBL
#' @export
org.Hs.egENSEMBL <- NULL
