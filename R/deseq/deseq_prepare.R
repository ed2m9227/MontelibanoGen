deseq_prepare <- function(counts, coldata, design) {
  
  stopifnot(
    !is.null(counts),
    !is.null(coldata),
    inherits(counts, c("matrix", "data.frame")), 
    inherits(coldata, c("data.frame", "DataFrame"))
  )
  
  counts <- as.matrix(counts)
  coldata <- as.data.frame(coldata)
  
  coldata <- coldata[colnames(counts), ,drop = FALSE]
  
  stopifnot(
    identical(colnames(counts), rownames(coldata))
  )

  DESeq2::DESeqDataSetFromMatrix(
    countData = counts,
    colData   = coldata,
    design    = design
  )
}
