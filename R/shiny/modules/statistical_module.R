statistical_module_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h4("Análisis Estadístico (DESeq2)"),
    
    fluidRow(
      box(
        width = 12,
        title = "Control de Análisis",
        status = "primary",
        solidHeader = TRUE,
        
        actionButton(
          ns("run_deseq"), 
          "Ejecutar DESeq2", 
          class = "btn-success btn-lg",
          icon = icon("play")
        ),
        
        hr(),
        verbatimTextOutput(ns("status"))
      )
    ),
    
    fluidRow(
      box(
        width = 12,
        title = "Resultados",
        status = "info",
        solidHeader = TRUE,
        DT::dataTableOutput(ns("table"))
      )
    )
  )
}

statistical_module_server <- function(id, logged_in, stored_data) {
  moduleServer(id, function(input, output, session) {
    
    # =========================================================================
    # EJECUTAR DESeq2 - ÚNICA UBICACIÓN
    # =========================================================================
    observeEvent(input$run_deseq, {
      
      req(logged_in())
      req(stored_data$dds)
      
      withProgress(message = 'Ejecutando DESeq2...', value = 0, {
        
        tryCatch({
          
          incProgress(0.3, detail = "Estimando dispersiones")
          
          output$status <- renderText("⏳ Ejecutando DESeq2...")
          
          # EJECUTAR ANÁLISIS
          result <- run_deseq_analysis(stored_data$dds)
          
          incProgress(0.6, detail = "Procesando resultados")
          
          # ALMACENAR EN stored_data
          stored_data$deseq <- result
          
          incProgress(1.0, detail = "Completado")
          
          log_event(
            user = "demo_user",
            action = "run_deseq",
            detail = paste("genes:", nrow(result$results),
                           "significativos:", sum(result$results$padj < 0.05,
                                                  na.rm = TRUE)))
          
          output$status <- renderText(paste(
            "✅ DESeq2 finalizado\n",
            "Genes totales:", nrow(result$results), "\n",
            "Genes significativos (padj < 0.05):", 
            sum(result$results$padj < 0.05, na.rm = TRUE)
          ))
          
          showNotification(
            "Análisis DESeq2 completado exitosamente",
            type = "message",
            duration = 5
          )
          
        }, error = function(e) {
          output$status <- renderText(paste("❌ Error:", e$message))
          showNotification(
            paste("Error en análisis:", e$message),
            type = "error",
            duration = 10
          )
        })
      })
    })
    
    # =========================================================================
    # TABLA DE RESULTADOS
    # =========================================================================
    output$table <- DT::renderDataTable({
      req(stored_data$deseq)
      
      DT::datatable(
        head(stored_data$deseq$results, 100),
        options = list(
          scrollX = TRUE,
          pageLength = 15
        )
      ) %>%
        DT::formatRound(columns = c("baseMean", "log2FoldChange", "lfcSE"), digits = 3) %>%
        DT::formatSignif(columns = c("pvalue", "padj"), digits = 3)
    })
  })
}