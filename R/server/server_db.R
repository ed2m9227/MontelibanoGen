server_db <- function(session) {
  
  con <- db_connect()
  
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
  
  con
}
