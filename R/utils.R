
#' utility for import of gene2go
#' @return data.frame with all human gene2go records
#' @export
fullread.gene2go = function() {
gene2gopath = system.file("extdata", "Hs.gene2go.parquet", package="org.Hs.eg.db3")
arrow::read_parquet(gene2gopath)
}

#' utility for import of gene2accession
#' @return data.frame with all human gene2go records
#' @export
fullread.gene2acc = function() {
gene2accpath = system.file("extdata", "Hs.gene2accession.parquet", package="org.Hs.eg.db3")
arrow::read_parquet(gene2accpath)
}

#' generalized utility for import of NCBI text
#' @return data.frame with all human gene2go records
#' @export
fullread.ncbitxt = function(stub="gene_info") {
path = system.file("extdata", sprintf("Hs.%s.parquet", stub), package="org.Hs.eg.db3")
arrow::read_parquet(path)
}


methods::setOldClass("hsParqEnv")

#' printer
#' @export
print.hsParqEnv = function(x, ...) methods::show(x)

#' conversion utility
#' @import methods
#' @importFrom BiocGenerics toTable
#' @param x hsParqEnv instance
#' @param \dots not used
#' @examples
#' toTable(org.Hs.egGO) |> head(10)
#' @export
setMethod("toTable", "hsParqEnv", 
 function(x, ...) {
  oo = as.list(x)
  nn = names(oo)
  ooo = unlist(oo,recursive=FALSE)
  if (is.numeric(ooo)) ooo = as.character(ooo)  # gene ids are integer
  lens = sapply(oo, length)
  gid = rep(nn, lens)
  if (is.list(ooo)) {
    dd = do.call(rbind, ooo)
    ee = data.frame(dd)
    ans = cbind(gene_id=gid, ee)
    rownames(ans) = NULL
    return(ans)
    }
  if (is.character(ooo)) {
    ans = data.frame(gid, ooo) # FIXED? ... need colname attribute for column
    names(ans)[1] = attr(x, "keycolname")
    names(ans)[2] = attr(x, "valcolname")
    return(ans)
    }
  else stop("env format not handled")
})

#' simple presentation
#' @export
setMethod("show", "hsParqEnv", function(object) {
 cat("hsParqEnv mapping for human\n")
})
