deseq_analysis <- function(dds) {
  
  dds <- DESeq2::DESeq(dds)
  
  list(
    dds     = dds,
    results = tryCatch(
      DESeq2::results(dds),
      error = function(e) NULL
    )
  )
}






