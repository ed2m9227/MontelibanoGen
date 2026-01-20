economic_module_ui <- function(id) {
  h4("Análisis económico (en desarrollo)")
}

economic_module_server <- function(id, stored_data) {
  moduleServer(id, function(input, output, session) {
    observe(
      {
        req(stored_data)
        # Lógica ecónómica aquí
      }
    )
  })
}