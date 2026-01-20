library(DESeq2)

prepare_deseq_dataset <- function(counts, coldata, desing = ~ condition) {
  
  stopifnot(
    is.matrix(counts) ||
    is.data.frame(counts),
    is.data.frame(coldata),
    ncol(counts) == nrow(coldata)
  )
  
  DESeq2::DESeqDataSetFromMatrix(
    countData = as.matrix(counts),
    colData   = coldata,
    design    = ~ condition
  )
  }