build_coldata <- function(counts) {
  
  stopifnot(!is.null(counts))
  stopifnot(ncol(counts) >= 2)
  
  samples <- colnames(counts)
  
  condition <- sub("_.*$", "", samples)
  
  coldata <- data.frame(
    row.names = samples,
    condition = factor(condition)
  )
  coldata
}