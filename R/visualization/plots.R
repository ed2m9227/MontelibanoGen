plot_volcano <- function(deseq_obj) {
  
  stopifnot(!is.null(deseq_obj$results))
  
  res <- as.data.frame(deseq_obj$results)
  
  res$log10padj <- -log10(res$padj)
  
  ggplot(res, aes(log2FoldChange, log10padj)) +
    geom_point(alpha = 0.6) +
    theme_minimal() +
    labs(
      title = "Volcano plot",
      x = "Log2 Fold Change",
      y = "-log10(p-adjusted)"
    )
}

plot_pca <- function(deseq_obj, intgroup = "condition") {
  
  stopifnot(!is.null(deseq_obj$dds))
  
  vst <- DESeq2::vst(deseq_obj$dds, blind = TRUE)
  
  pca_data <- DESeq2::plotPCA(vst, intgroup = intgroup, returnData = TRUE)
  percentVar <- round(100 * attr(pca_data, "percentVar"))
  
  ggplot(pca_data, aes(PC1, PC2, color = .data[[intgroup]])) +
    geom_point(size = 3) +
    theme_minimal() +
    labs(
      title = "PCA",
      x = paste0("PC1: ", percentVar[1], "%"),
      y = paste0("PC2: ", percentVar[2], "%")
    )
}

plot_ma <- function(deseq_obj) {
  
  stopifnot(!is.null(deseq_obj$results))
  
  res <- as.data.frame(deseq_obj$results)
  
  ggplot(res, aes(baseMean, log2FoldChange)) +
    geom_point(alpha = 0.6) +
    scale_x_log10() +
    theme_minimal() +
    labs(
      title = "MA plot",
      x = "Mean expression",
      y = "Log2 Fold Change"
    )
}
