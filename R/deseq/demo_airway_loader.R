#' Cargar dataset demo airway (SIN ejecutar DESeq2)
#'
#' @return Lista con counts, coldata
#' @export
load_airway_data <- function() {
  
  if (!requireNamespace("airway", quietly = TRUE)) {
    stop("El paquete 'airway' no está instalado. Instálelo con: BiocManager::install('airway')")
  }
  
  library(airway)
  data(airway)
  
  # Extraer matriz de conteos
  counts <- assay(airway)
  
  # Extraer coldata
  coldata <- as.data.frame(colData(airway))
  
  # Simplificar coldata: solo dex (tratamiento)
  coldata <- coldata[, "dex", drop = FALSE]
  coldata$dex <- factor(coldata$dex)
  
  # RETORNAR SOLO DATOS CRUDOS
  list(
    counts = counts,
    coldata = coldata
  )
}