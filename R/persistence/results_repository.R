save_results <- function(con, results, meta) {
  
  stopifnot(
    inherits(con, "SQLiteConnection"),
    is.data.frame(results)
  )
  
  results_tbl <- as.data.frame(results)
  
  DBI::dbWriteTable(
    con,
    "deseq_results",
    results_tbl,
    overwrite = TRUE
  )
  
  DBI::dbWriteTable(
    con,
    "sample_metadata",
    meta,
    overwrite = TRUE
  )
}
