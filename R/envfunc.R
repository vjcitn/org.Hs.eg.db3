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

