

.onLoad <- function(libname, pkgname) {
  makeGOENV(pkgname)
  makeGO2EGENV(pkgname)
  makeALIAS2EGENV(pkgname)
  makeegENSEMBL(pkgname, "org.Hs.egENSEMBL")
  makeegENSEMBL2EG(pkgname, "org.Hs.egENSEMBL2EG")
  makeegENSEMBLTRANS(pkgname, "org.Hs.egENSEMBLTRANS")
  makeegENSEMBLTRANS2EG(pkgname, "org.Hs.egENSEMBLTRANS2EG")
  makeegENSEMBLPROT(pkgname, "org.Hs.egENSEMBLPROT")
  makeegENSEMBLPROT2EG(pkgname, "org.Hs.egENSEMBLPROT2EG")
}

