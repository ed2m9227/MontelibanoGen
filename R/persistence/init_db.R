library(DBI)

init_database <- function(con, schema_file = "R/persistence/schema_postgres.sql") {
  
  if (!file.exists(schema_file)) {
    stop("Schema file not found: ", schema_file)
  }
  
  sql <- readLines(schema_file, warn = FALSE)
  
  # Unir líneas y separar por ;
  statements <- unlist(strsplit(paste(sql, collapse = "\n"), ";"))
  
  statements <- trimws(statements)
  statements <- statements[nzchar(statements)]
  
  for (stmt in statements) {
    dbExecute(con, stmt)
  }
  
  invisible(TRUE)
}