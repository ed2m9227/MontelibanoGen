library(DBI)
library(uuid)

save_deseq_results <- function(out, metadata, con) {
  
  analysis_id <- UUIDgenerate()
  
  # 1. Guardar análisis
  dbExecute(
    con,
    "
    INSERT INTO genomics.deseq_analysis
    (analysis_id, organism, assay_type, design_formula, contrast)
    VALUES ($1, $2, $3, $4, $5)
    ",
    params = list(
      analysis_id,
      metadata$organism,
      metadata$assay_type,
      metadata$design,
      metadata$contrast
    )
  )
  
  # 2. Preparar resultados
  res_df <- as.data.frame(out$results)
  res_df$gene_id <- rownames(res_df)
  ## Traducción expliscita de R a SQL
  res_df$db_log2_fc <- res_df$log2FoldChange
  res_df$db_lfc_se <- res_df$lfcSE
  
  res_df$analysis_id <- analysis_id
  
  res_df <- res_df[, c(
    "analysis_id",
    "gene_id",
    "baseMean",
    "log2FoldChange",
    "lfcSE",
    "stat",
    "pvalue",
    "padj"
  )]
  
  colnames(res_df) <- c(
    "analysis_id",
    "gene_id",
    "base_mean",
    "log2_fc",
    "lfc_se",
    "stat",
    "pvalue",
    "padj"
  )
  
  # 3. Guardar resultados
  dbWriteTable(
    con,
    Id(schema = "genomics", table = "deseq_results"),
    res_df,
    append = TRUE,
    row.names = FALSE
  )
  
  return(analysis_id)
}