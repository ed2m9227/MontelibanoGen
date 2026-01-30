check_demo_login <- function(input, rv) {
  observeEvent(input$demo_login_btn, {
    rv$demo_mode <- TRUE
  })
}
