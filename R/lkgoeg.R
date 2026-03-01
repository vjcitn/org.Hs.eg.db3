
fullread = function() {
gene2gopath = system.file("extdata", "Hs.gene2go.parquet", package="org.Hs.eg.db3")
arrow::read_parquet(gene2gopath)
}

toTable = function(env) {
  oo = as.list(env)
  nn = names(oo)
  ooo = unlist(oo,recursive=FALSE)
  lens = sapply(oo, length)
  gid = rep(nn, lens)
  dd = do.call(rbind, ooo)
  ee = data.frame(dd)
  ans = cbind(gene_id=gid, ee)
  rownames(ans) = NULL
  ans
}

