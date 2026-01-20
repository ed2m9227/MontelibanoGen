# =========================================================
# DESeq2 pipeline
# Input: GenData
# Output: DESeqResults
# =========================================================

run_deseq2 <- function(gen_data) {
  
  stopifnot(inherits(gen_data, "GenData"))
  
  counts <- gen_data$data
  
  colData <- data.frame(
    condition = c("control", "control", "treated", "treated"),
    row.names = colnames(counts)
  )
  
  if (!all(rownames(colData) == colnames(counts))) {
    stop("colData no coincide con las columnas de conteos")
  }
  
  dds <- DESeq2::DESeqDataSetFromMatrix(
    countData = counts,
    colData   = colData,
    design    = ~ condition
  )
  
  dds <- dds[rowSums(DESeq2::counts(dds)) >= 10, ]
  
  dds <- DESeq2::DESeq(dds)
  
  DESeq2::results(dds)
}