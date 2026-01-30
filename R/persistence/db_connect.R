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
  DBI::dbConnect(
    RSQLite::SQLite(),
    "data/app.sqlite"
  )
}

