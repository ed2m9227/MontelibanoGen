library(DBI)
library(uuid)

save_deseq_results <- function(out, metadata, con) {
  
  analysis_id <- UUIDgenerate()
  
  # Insert analysis metadata
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
  
  res <- as.data.frame(out$results)
  res$gene_id <- rownames(res)
  res$analysis_id <- analysis_id
  
  res <- res[, c(
    "analysis_id",
    "gene_id",
    "log2FoldChange",
    "pvalue",
    "padj"
  )]
  
  colnames(res) <- c(
    "analysis_id",
    "gene_id",
    "log2fc",
    "pvalue",
    "padj"
  )
  
  dbWriteTable(
    con,
    Id(schema = "genomics", table = "deseq_results"),
    res,
    append = TRUE,
    row.names = FALSE
  )
  
  return(analysis_id)
}