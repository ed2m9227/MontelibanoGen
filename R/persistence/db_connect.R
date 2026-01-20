library(DBI)
library(RPostgres)

db_connect <- function() {
  dbConnect(
    RPostgres::Postgres(),
    host     = "127.0.0.1",
    port     = 5432,
    dbname   = "postgres",
    user     = "postgres",
    password = "Ex nihilo, nihil fit"
  )
}
