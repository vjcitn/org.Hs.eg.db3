#' class for parquet representation of GO
#' @note This class just serves as a bridge to parquet files that emulate
#' the former SQLite schema of AnnotationDbi-based GO.db.
#' @import methods
#' @export
setClass("OrgParq", representation(conn="ANY"))

#' display for parquet representation of GO
#' @param object instance of OrgParq
#' @export
setMethod("show", "OrgParq", function(object) {
  cat(sprintf("org.xx.yy.db analog for Bioconductor %s\n", as.character(BiocManager::version())))
})

#' connector, called in .onLoad
.org.Hs.eg.db3 = function() {
    allcon = arrow::open_dataset(system.file("extdata", package="org.Hs.eg.db3"))
    new("OrgParq", conn=list(allcon=allcon))
}

#' connector exported
#' @export
org.Hs.eg.db <- NULL


.keytypes = c(
"ALIAS", "ENSEMBL", "ENSEMBLPROT", "ENSEMBLTRANS", 
"ENTREZID", "GENENAME", 
"GENETYPE", "GO", "MAP", "OMIM", 
"PFAM", "PMID", "PROSITE", "REFSEQ", "SYMBOL", 
"UNIPROT")
 
.columns = c(
"ALIAS", "ENSEMBL", "ENSEMBLPROT", "ENSEMBLTRANS", 
"ENTREZID", "GENENAME", 
"GENETYPE", "GO", "MAP", "OMIM", 
"PATH", "PFAM", "PMID", "PROSITE", "REFSEQ", "SYMBOL", 
"UCSCKG", "UNIPROT")

#setMethod("select", "OrgParq", function(x, keys, columns, keytype, ...) {
## backwards compatibility of missing keytype
#    if (missing(keytype)) {
#     message("missing keytype is allowed for backwards compatibility; it will become a warning in bioc > 3.23")
#     keytype = "ENTREZID"
#     }


