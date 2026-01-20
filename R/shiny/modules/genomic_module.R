genomic_module_ui <- function(id) {
  h4("Análisis genómico (en desarrollo)")
}

genomic_module_server <- function(id, logged_in, stored_data) {
  moduleServer(id, function(input, output, session) {
    
  observe({
    if (!is.null(logged_in)) { req(logged_in())}
              print("Genomic module activo")
              str(stored_data)
    })
  })
}