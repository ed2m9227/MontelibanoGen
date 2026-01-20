# =========================================================
# CSV RNA-seq counts handler
# Lee, valida y construye GenData
# =========================================================

read_csv_counts <- function(file_path,
                            organism = "Homo sapiens",
                            assay_type = "RNA-seq") {
  
  # ---- 1. Lectura segura ----
  counts <- tryCatch(
    {
      read.csv(file_path, row.names = 1, check.names = FALSE)
    },
    error = function(e) {
      stop("No se pudo leer el CSV: ", e$message)
    }
  )
  
  # ---- 2. Validaciones estructurales ----
  
  if (!is.data.frame(counts)) {
    stop("El archivo no produjo un data.frame válido")
  }
  
  if (nrow(counts) == 0 || ncol(counts) == 0) {
    stop("El CSV está vacío o mal estructurado")
  }
  
  # Genes únicos
  if (any(duplicated(rownames(counts)))) {
    stop("Los nombres de genes (filas) deben ser únicos")
  }
  
  # Conteos numéricos
  if (!all(sapply(counts, is.numeric))) {
    stop("Todas las columnas deben ser numéricas (conteos)")
  }
  
  # No negativos
  if (any(counts < 0, na.rm = TRUE)) {
    stop("Los conteos no pueden ser negativos")
  }
  
  # Enteros (DESeq2 lo exige)
  if (!all(counts %% 1 == 0, na.rm = TRUE)) {
    stop("Los conteos deben ser enteros (no decimales)")
  }
  
  # NA críticos
  if (any(is.na(counts))) {
    stop("El CSV contiene valores NA; deben resolverse antes")
  }
  
  # ---- 3. Metadata mínima ----
  
  metadata <- list(
    n_genes = nrow(counts),
    n_samples = ncol(counts),
    sample_names = colnames(counts)
  )
  
  # ---- 4. Construcción del GenData ----
  
  GenData(
    data = counts,
    data_type = "csv_counts",
    organism = organism,
    assay_type = assay_type,
    metadata = metadata,
    source_file = basename(file_path)
  )
}