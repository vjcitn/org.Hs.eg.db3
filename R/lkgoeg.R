
#' utility for import of gene2go
#' @return data.frame with all human gene2go records
#' @export
fullread.gene2go = function() {
gene2gopath = system.file("extdata", "Hs.gene2go.parquet", package="org.Hs.eg.db3")
arrow::read_parquet(gene2gopath)
}

methods::setOldClass("hsParqEnv")

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
  lens = sapply(oo, length)
  gid = rep(nn, lens)
  dd = do.call(rbind, ooo)
  ee = data.frame(dd)
  ans = cbind(gene_id=gid, ee)
  rownames(ans) = NULL
  ans
})

