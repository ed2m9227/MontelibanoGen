load_demo_airway <- function() {
  
  if (!requireNamespace("airway", quietly = TRUE)) {
    stop("Paquete 'airway' no disponible")
  }
  
  data("airway", package = "airway")
  
  list(
    counts  = SummarizedExperiment::assay(airway),
    coldata = as.data.frame(SummarizedExperiment::colData(airway))
  )
}




