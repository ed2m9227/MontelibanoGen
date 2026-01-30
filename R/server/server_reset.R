server_reset <- function(input, rv) {
  
  observeEvent(input$reset_analysis, {
    rv$results <- NULL
    gc()
  })
  
}
