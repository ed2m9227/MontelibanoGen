source("global.R")

ui <- dashboard_ui()

server <- function(input, output, session) {
  
  logged_in <- reactiveVal(FALSE)
  
  stored_data <- reactiveValues(
    counts = NULL,
    coldata = NULL,
    deseq = NULL
  )
  
  dashboard_server(
    input,
    output,
    session,
    logged_in,
    stored_data,
    con
  )
}

shinyApp(ui, server)