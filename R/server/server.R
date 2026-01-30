function(input, output, session) {
  
  check_demo_login(input, rv)
  
  rv <- reactiveValues(results = NULL)
  
  con <- server_db(session)
  
  server_deseq(input, rv, con)
  server_demo_data(input, rv)
  server_reset(input, rv)
  
  dashboard_server(input, output, session, rv)
}
