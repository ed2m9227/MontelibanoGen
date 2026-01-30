qc_pca <- function(dds, intgroup = "condition") {
  
  vsd <- DESeq2::varianceStabilizingTransformation(dds, blind = TRUE)
  
  pca_data <- DESeq2::plotPCA(
    vsd,
    intgroup = intgroup,
    returnData = TRUE
  )
  
  percent_var <- round(100 * attr(pca_data, "percentVar"))
  
  p <- ggplot2::ggplot(
    pca_data,
    ggplot2::aes(PC1, PC2, color = .data[[intgroup]])
  ) +
    ggplot2::geom_point(size = 3, alpha = 0.8) +
    ggplot2::labs(
      x = paste0("PC1: ", percent_var[1], "%"),
      y = paste0("PC2: ", percent_var[2], "%"),
      title = "PCA"
    ) +
    ggplot2::theme_minimal()
  
  list(
    plot = p,
    data = pca_data
  )
}

qc_dispersion <- function(dds) {
  
  dds <- DESeq2::estimateDispersions(dds)
  
  data.frame(
    mean = mcols(dds)$baseMean,
    dispersion = mcols(dds)$dispersion
  )
}

qc_ma <- function(dds) {
  
  dds <- DESeq2::DESeq(dds, test = "Wald", fitType = "parametric")
  
  as.data.frame(DESeq2::results(dds))
}

run_qc <- function(dds, condition_col = "condition") {
  
  list(
    pca = qc_pca(dds, condition_col),
    dispersion = qc_dispersion(dds),
    ma = qc_ma(dds)
  )
}
