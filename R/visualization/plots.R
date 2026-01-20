library(ggplot2)

plot_pca <- function(dds) {
  vsd <- DESeq2::vst(dds, blind = TRUE)
  p <- DESeq2::plotPCA(vsd, intgroup = "condition")
  p
}

plot_ma <- function(res) {
  DESeq2::plotMA(res, ylim = c(-5, 5))
}

plot_volcano <- function(res) {
  df <- as.data.frame(res)
  df$gene <- rownames(df)
  
  df$significant <- with(df, padj < 0.05 & abs(log2FoldChange) > 1)
  
  ggplot(df, aes(
    x = log2FoldChange,
    y = log10(padj),
    color = significant
  )) +
    geom_point(alpha = 0.6) + scale_color_manual(values = c("grey", "red")) +
    theme_minimal() + labs(
      title = "Visualización Volcano",
      x = "log2 Fold Change",
      y = "-log10 adjusted p-value"
    )
  
}