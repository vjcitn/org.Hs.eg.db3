

.onLoad <- function(libname, pkgname) {

ns <- getNamespace(pkgname)
   
  # Remove if exists
  if (exists("org.Hs.eg.db", envir = ns, inherits = FALSE)) {
    if (bindingIsLocked("org.Hs.eg.db", ns)) {
      unlockBinding("org.Hs.eg.db", ns)
    }
    rm(list = "org.Hs.eg.db", envir = ns)
  }
   
  # Now create the active binding for GO.db
  makeActiveBinding("org.Hs.eg.db", .org.Hs.eg.db3, ns)

  makeGOENV(pkgname)
  makeGO2EGENV(pkgname)
  makeALIAS2EGENV(pkgname)
  makeegENSEMBL(pkgname, "org.Hs.egENSEMBL")
  makeegENSEMBL2EG(pkgname, "org.Hs.egENSEMBL2EG")
  makeegENSEMBLTRANS(pkgname, "org.Hs.egENSEMBLTRANS")
  makeegENSEMBLTRANS2EG(pkgname, "org.Hs.egENSEMBLTRANS2EG")
  makeegENSEMBLPROT(pkgname, "org.Hs.egENSEMBLPROT")
  makeegENSEMBLPROT2EG(pkgname, "org.Hs.egENSEMBLPROT2EG")
  makeegMAP(pkgname, "org.Hs.egMAP")
  makeegMAP2EG(pkgname, "org.Hs.egMAP2EG")
  makeegGENETYPE(pkgname, "org.Hs.egGENETYPE")
  makeegGENENAME(pkgname, "org.Hs.egGENENAME") 
  makeegSYMBOL(pkgname, "org.Hs.egSYMBOL")
  makeegOMIM(pkgname, "org.Hs.egOMIM")
  makeegOMIM2EG(pkgname, "org.Hs.egOMIM2EG")
}

