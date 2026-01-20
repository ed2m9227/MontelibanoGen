visualization_module_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h4("Visualización de Resultados"),
    
    fluidRow(
      box(
        width = 6,
        title = "PCA Plot",
        status = "primary",
        solidHeader = TRUE,
        plotOutput(ns("pca_plot"), height = "400px")
      ),
      
      box(
        width = 6,
        title = "MA Plot",
        status = "primary",
        solidHeader = TRUE,
        plotOutput(ns("ma_plot"), height = "400px")
      )
    ),
    
    fluidRow(
      box(
        width = 12,
        title = "Volcano Plot",
        status = "info",
        solidHeader = TRUE,
        plotly::plotlyOutput(ns("volcano_plot"), height = "500px")
      )
    )
  )
}

visualization_module_server <- function(id, logged_in = NULL, stored_data) {
  moduleServer(id, function(input, output, session) {
    
    # =========================================================================
    # PCA PLOT - FIX: Detectar columna de diseño dinámicamente
    # =========================================================================
    output$pca_plot <- renderPlot({
      
      if (!is.null(logged_in)) req(logged_in())
      req(stored_data$deseq)
      
      dds <- stored_data$deseq$dds
      
      # CRÍTICO: Detectar la columna del diseño dinámicamente
      design_formula <- design(dds)
      design_vars <- all.vars(design_formula)
      
      # Usar la primera variable del diseño (condition, dex, etc.)
      intgroup_var <- design_vars[1]
      
      # Transformación variance stabilizing
      vsd <- DESeq2::varianceStabilizingTransformation(dds, blind = FALSE)
      
      # PCA plot con intgroup dinámico
      DESeq2::plotPCA(vsd, intgroup = intgroup_var) +
        theme_minimal(base_size = 14) +
        ggtitle("PCA - Análisis de Componentes Principales")
    })
    
    # =========================================================================
    # MA PLOT
    # =========================================================================
    output$ma_plot <- renderPlot({
      
      req(stored_data$deseq)
      
      # Usar el objeto DESeqResults directamente
      res_obj <- DESeq2::results(stored_data$deseq$dds)
      
      DESeq2::plotMA(res_obj, ylim = c(-5, 5))
      title("MA Plot - Log2FC vs Mean Expression")
    })
    
    # =========================================================================
    # VOLCANO PLOT - FIX: Cambiar variable de tilde
    # =========================================================================
    output$volcano_plot <- plotly::renderPlotly({
      
      req(stored_data$deseq)
      
      res <- as.data.frame(stored_data$deseq$results)
      
      # Añadir -log10(pvalue)
      res$neg_log10_pvalue <- -log10(res$pvalue)
      
      # Clasificar genes
      res$significance <- ifelse(
        is.na(res$padj), "NS",
        ifelse(res$padj < 0.05, "Significant", "NS")
      )
      
      # Plotly
      p <- ggplot(res, aes(
        x = log2FoldChange,  # SIN tilde negativa
        y = neg_log10_pvalue,
        color = significance,
        text = paste0(
          "Gene: ", gene_id, "<br>",
          "log2FC: ", round(log2FoldChange, 2), "<br>",
          "padj: ", formatC(padj, format = "e", digits = 2)
        )
      )) +
        geom_point(alpha = 0.6, size = 2) +
        scale_color_manual(values = c("Significant" = "red", "NS" = "gray60")) +
        geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "blue") +
        geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "blue") +
        theme_minimal(base_size = 14) +
        labs(
          title = "Volcano Plot",
          x = "Log2 Fold Change",
          y = "-log10(p-value)",
          color = "Significance"
        )
      
      plotly::ggplotly(p, tooltip = "text")
    })
  })
}