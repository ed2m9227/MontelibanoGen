deseq_prepare <- function(counts, coldata, design) {
  
  stopifnot(
    !is.null(counts),
    !is.null(coldata),
    inherits(counts, "matrix") || is.data.frame(counts),
    is.data.frame(coldata)
  )

  DESeq2::DESeqDataSetFromMatrix(
    countData = counts,
    colData   = coldata,
    design    = design
  )
}
