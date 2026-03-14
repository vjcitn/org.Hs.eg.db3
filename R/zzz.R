

.onLoad <- function(libname, pkgname) {
  makeGOENV(pkgname)
  makeGO2EGENV(pkgname)
  makeALIAS2EGENV(pkgname)
  makeegENSEMBL(pkgname, "org.Hs.egENSEMBL")
}

