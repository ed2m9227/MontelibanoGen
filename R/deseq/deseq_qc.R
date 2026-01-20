library(DESeq2)
library(ggplot2)
library(dplyr)
library(tibble)

qc_pca <- function(dds, intgroup = "condition") {
  
  vsd <- varianceStabilizingTransformation(dds, blind = TRUE)
  pca_data <- plotPCA(vsd, intgroup = intgroup, returnData = TRUE)
  
  percent_var <- round(100 * attr(pca_data, "percentVar"))
  
  p <- ggplot(pca_data,
              aes(x = PC1, y = PC2, color = .data[[intgroup]])) +
    geom_point(size = 3, alpha = 0.8) +
    xlab(paste0("PC1: ", percent_var[1], "%")) +
    ylab(paste0("PC2: ", percent_var[2], "%")) +
    theme_minimal()
  
  list(
    plot = p,
    data = pca_data
  )
}

qc_dispersion <- function(dds) {
  
  dds <- estimateDispersions(dds)
  
  plotDispEsts(dds)
}

qc_ma <- function(dds) {
  
  dds <- DESeq(dds, test = "Wald", fitType = "parametric")
  
  res <- results(dds)
  
  plotMA(res, ylim = c(-5, 5))
}

run_qc <- function(dds, condition_col = "condition") {
  
  message("▶ Running PCA QC")
  pca <- qc_pca(dds, condition_col)
  
  message("▶ Running dispersion QC")
  qc_dispersion(dds)
  
  message("▶ Running MA QC")
  qc_ma(dds)
  
  invisible(list(
    pca = pca
  ))
}