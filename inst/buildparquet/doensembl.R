
library(DBI)
library(duckdb)

con = dbConnect(duckdb())

dbExecute(con, "
  CREATE TABLE gene2ensembl AS
  SELECT *
  FROM read_csv_auto(
    'gene2ensembl.gz',
    delim = '\t',
    header = true,
    compression = 'gzip',
    ignore_errors=TRUE
  )
")

dbExecute(con, "COPY (FROM gene2ensembl) TO 'gene2ensembl.parquet' (FORMAT parquet, COMPRESSION zstd, COMPRESSION_LEVEL 15)")
