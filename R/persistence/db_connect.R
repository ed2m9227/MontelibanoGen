library(DBI)
library(RSQLite)
# library(RPostgres)
# 
# db_connect <- function() {
#   dbConnect(
#     RPostgres::Postgres(),
#     host     = "",
#     port     = 5432,
#     dbname   = "postgres",
#     user     = "postgres",
#     password = "Ex nihilo, nihil fit"
#   )
# }

db_connect <- function() {
  db_file <- "data/dbase.sqlite"
  
  # Si no existe, crearla
  if(!dir.exists(db_file)) {
    dir.create("data")
  }
  
  #Conectar (Crea archivo si no existe)
  con <- dbConnect(SQLite(), db_file)
  
  #Blindaje
  dbExecute(con, "PRAGMA journal_mode = WAL;")
  dbExecute(con, "PRAGMA foreign_keys = ON;")
  
  #Garantizar tablas mínimas
  dbExecute(con, "CREATE TABLE IF NOT EXISTS dbase (key TEXT PRIMARY KEY, 
            VALUE TEXT, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
  con
  
}

