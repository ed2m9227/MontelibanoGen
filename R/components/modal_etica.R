modal_etica_server <- function(input, output, session) {
  observeEvent(input$show_modal_etica, {
    showModal(modalDialog(
      title = tags$div(
        icon("balance-scale"),
        "Información Ética y Legal"
      ),
      size = "l",
      easyClose = TRUE,
      
      tags$div(
        style = "font-size: 14px;",
        
        tags$h4("Uso exclusivo para investigación"),
        tags$p(
          "Esta plataforma ha sido desarrollada con fines de investigación biomédica y ",
          tags$strong("NO debe utilizarse para diagnóstico clínico, tratamiento médico o toma de decisiones clínicas.")
        ),
        
        tags$h4("Consentimiento informado"),
        tags$p(
          "Todos los datos procesados en esta plataforma deben contar con el ",
          tags$strong("consentimiento informado previo"),
          " de los participantes o estar debidamente anonimizados según normativa aplicable."
        ),
        
        tags$h4("Privacidad y protección de datos"),
        tags$ul(
          tags$li("Los datos cargados son procesados localmente durante la sesión"),
          tags$li("No se almacenan datos en servidores externos"),
          tags$li("Es responsabilidad del usuario garantizar la anonimización de datos sensibles")
        ),
        
        tags$h4("Limitaciones"),
        tags$ul(
          tags$li("Software en fase de prototipo/desarrollo"),
          tags$li("Los resultados deben ser validados por expertos"),
          tags$li("No sustituye el criterio profesional médico o científico")
        ),
        
        tags$h4("Contacto"),
        tags$p(
          "Para consultas sobre aspectos éticos o uso apropiado: ",
          tags$a(href = "mailto:e2m9227@gmail.com", "e2m9227@gmail.com")
        ),
        
        tags$hr(),
        tags$p(
          style = "font-size: 12px; color: #666;",
          " Demostrativo - MontelibanoGen © 2025"
        )
      ),
      
      footer = modalButton("Cerrar")
    ))
  })
}