make_sublist = function(x) {
   nr = nrow(x)
   vv = vector("list", nrow(x))
   for (i in seq_len(nr)) 
     vv[[i]] = list(GOID=x$GO_ID[i], Evidence=x$Evidence[i], Ontology=x$ShortCategory[i])
   names(vv) = x$GO_ID
   vv
}



# NOTE
# > get("1", org.Hs.egGO)[1:4]
# $`GO:0002764`
# $`GO:0002764`$GOID
# [1] "GO:0002764"
# 
# $`GO:0002764`$Evidence
# [1] "IBA"
# 
# $`GO:0002764`$Ontology
# [1] "BP"
# 
# 
# $`GO:0005576`
# $`GO:0005576`$GOID
# [1] "GO:0005576"
# 
# $`GO:0005576`$Evidence
# [1] "HDA"
# 
# $`GO:0005576`$Ontology
# [1] "CC"
# 


remapCat = function(x) {
  mp = c("Function", "Process", "Component")
  mpt = c("MF", "BP", "CC")
  names(mpt) = mp
  mpt[x]
}

#' self-describing object for GO interface
#' @export
org.Hs.egGO  <- NULL

.onLoad <- function(libname, pkgname) {
  ns <- getNamespace(pkgname)

  ff = fullread()
  ff$ShortCategory = remapCat(ff$Category)

#
# this is somewhat clumsy but works to establish a functional environment
# note that GO2ALLEGS uses the GO hierarchy to add genes mapped to conceptual offspring of term
#

## resource: GO

  CURRENT = "org.Hs.egGO"
  CURRENTE = "org.Hs.egGO_env"

# process data.frame

  bygene = split(ff, ff$GeneID)
  genel = lapply(bygene, make_sublist)
  names(genel) = names(bygene)

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

## DONE WITH GO

## resource: GO2ALLEGS

}

# this was useful with GO.db3
  # Remove if exists
  #if (exists(CURRENT, envir = ns, inherits = FALSE)) {
  #  if (bindingIsLocked(CURRENT, ns)) {
  #    unlockBinding(CURRENT, ns)
  #  }
  #  rm(list = CURRENT, envir = ns)
  #}
