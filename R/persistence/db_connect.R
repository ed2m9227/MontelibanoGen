# library(RPostgres)
# 
# db_connect <- function() {
#   dbConnect(
#     RPostgres::Postgres(),
#     host     = "",
#     port     = 5432,
#     dbname   = "postgres",
#     user     = "postgres",
#     password = Sys.getenv("DB_PASSWORD")
#   )
# }

db_connect <- function() {
  DBI::dbConnect(
    RSQLite::SQLite(),
    "data/app.sqlite"
  )
}

