source("global.R")

ui <- dashboard_ui()

server <- function(input, output, session) {
  
  rv <- reactiveValues()
  
  dashboard_server(
    input,
    output,
    session,
    rv
  )
}

shinyApp(ui, server)
