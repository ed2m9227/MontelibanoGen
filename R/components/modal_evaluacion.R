show_evaluation_modal <- function(){
  showModal(
    modalDialog(
      title = "Modo Evaluación Académica",
      HTML("<p><b>MontelibanoGen</b> se encuentra en fase de evaluación.</p>
           <ul><li> Uso exlusivo para investigación y docencia</li>
           <li>No destinado a diagnóstico clínico</li>
           <li>Datos cargados con responsabilidad del usuario</li></ul>"),
      easyClose = TRUE,
      footer = modalButton("Entendido")
    )
  )
}