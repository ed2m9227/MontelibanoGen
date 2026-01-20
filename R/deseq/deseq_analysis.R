library(DESeq2)

#' Ejecutar análisis DESeq2 completo
#'
#' @param dds DESeqDataSet objeto
#' @param contrast Vector de contraste (opcional)
#' @return Lista con dds procesado y resultados como dataframe
#' 
run_deseq_analysis <- function(dds, contrast = NULL) {
  
  stopifnot(inherits(dds, "DESeqDataSet"))
  
  # Ejecutar DESeq2
  dds <- DESeq2::DESeq(dds)
  
  # Extraer resultados
  if (!is.null(contrast)) {
    res <- DESeq2::results(dds, contrast = contrast)
  } else {
    res <- DESeq2::results(dds)
  }
  
  # Convertir a dataframe y añadir gene_id
  res_df <- as.data.frame(res)
  res_df$gene_id <- rownames(res_df)
  
  # Reordenar columnas
  res_df <- res_df[, c("gene_id", "baseMean", "log2FoldChange", 
                       "lfcSE", "stat", "pvalue", "padj")]
  
  # Ordenar por p-valor ajustado
  res_df <- res_df[order(res_df$padj, na.last = TRUE), ]
  
  # Retornar estructura consistente
  list(
    dds = dds,           # DESeqDataSet procesado
    results = res_df     # DataFrame con resultados
  )
}