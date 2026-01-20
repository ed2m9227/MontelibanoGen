footer_ui <- function() {
  tags$footer(
    class = "main-footer-custom",
    tags$div(
      tags$span(
        "Plataforma de investigación biomédica · Uso exclusivo para investigación · No diagnóstico clínico · Prototipo en desarrollo · "
      ),
      tags$a(
        href = "#",
        id = "link_etica",
        "Información ética",
        style = "color: #3c8dbc; text-decoration: none; cursor: pointer;",
        onclick = "Shiny.setInputValue('show_modal_etica', Math.random());"
      ),
      tags$br(),
      tags$span(
        "© 2025 — Eduardo Martínez",
        style = "color: #666;"
      )
    )
  )
}