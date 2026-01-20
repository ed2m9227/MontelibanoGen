reports_module_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h4("Generación de Reportes"),
    
    fluidRow(
      box(
        width = 12,
        title = "Estado del Análisis",
        status = "info",
        solidHeader = TRUE,
        
        verbatimTextOutput(ns("analysis_status")),
        
        hr(),
        
        tableOutput(ns("summary_table"))
      )
    ),
    
    fluidRow(
      box(
        width = 12,
        title = "Exportar Resultados",
        status = "success",
        solidHeader = TRUE,
        
        downloadButton(ns("download_report"), "Descargar Reporte (TXT)", class = "btn-primary"),
        
        hr(),
        
        downloadButton(ns("download_csv"), "Descargar Resultados (CSV)", class = "btn-success")
      )
    )
  )
}

reports_module_server <- function(id, logged_in, stored_data) {
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    # ============================================
    # VALIDACIÓN DE DATOS
    # ============================================
    
    analysis_ready <- reactive({
      req(stored_data$counts, stored_data$coldata)
      TRUE
    })
    
    # ============================================
    # ESTADO DEL ANÁLISIS
    # ============================================
    
    output$analysis_status <- renderText({
      
      req(logged_in())
      
      if (!analysis_ready()) {
        return("❌ No hay análisis cargado")
      }
      
      if (is.null(stored_data$deseq)) {
        return("⚠️ Datos cargados pero DESeq2 no ejecutado")
      }
      
      n_sig <- sum(stored_data$deseq$results$padj < 0.05, na.rm = TRUE)
      
      paste0(
        "✅ Análisis completo\n",
        "Genes: ", nrow(stored_data$counts), "\n",
        "Muestras: ", ncol(stored_data$counts), "\n",
        "Genes significativos: ", n_sig
      )
    })
    
    # ============================================
    # TABLA RESUMEN
    # ============================================
    
    output$summary_table <- renderTable({
      
      req(logged_in(), analysis_ready())
      
      data.frame(
        Concepto = c("Genes totales", "Muestras", "DESeq2 ejecutado"),
        Valor = c(
          nrow(stored_data$counts),
          ncol(stored_data$counts),
          ifelse(is.null(stored_data$deseq), "No", "Sí")
        )
      )
    })
    
    # ============================================
    # DESCARGAR REPORTE TXT (SAFE)
    # ============================================
    
    output$download_report <- downloadHandler(
      
      filename = function() {
        paste0("reporte_genomico_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt")
      },
      
      content = function(file) {
        
        # VALIDACIÓN CRÍTICA
        req(logged_in())
        req(analysis_ready())
        
        # Generar reporte en memoria
        report_lines <- c(
          "===========================================",
          "  REPORTE GENÓMICO - MontelibanoGen",
          "===========================================",
          "",
          paste("Fecha:", Sys.time()),
          "",
          "--- DATOS CARGADOS ---",
          paste("Genes:", nrow(stored_data$counts)),
          paste("Muestras:", ncol(stored_data$counts)),
          ""
        )
        
        if (!is.null(stored_data$deseq)) {
          
          tryCatch({
            
            n_sig <- sum(stored_data$deseq$results$padj < 0.05, na.rm = TRUE)
            
            report_lines <- c(
              report_lines,
              "--- ANÁLISIS DESeq2 ---",
              "Estado: Completado",
              paste("Genes significativos (padj < 0.05):", n_sig),
              "",
              "--- TOP 10 GENES ---"
            )
            
            
            # Ordenar por padj
            top10 <- head(
              stored_data$deseq$results[order(stored_data$deseq$results$padj), ], 
              10
            )
            
            for (i in 1:nrow(top10)) {
              line <- sprintf(
                "%d. %s | log2FC=%.2f | padj=%.2e",
                i,
                top10$gene_id[i],
                top10$log2FoldChange[i],
                top10$padj[i]
              )
              report_lines <- c(report_lines, line)
            }
            
          }, error = function(e) {
            report_lines <<- c(
              report_lines,
              "--- ANÁLISIS DESeq2 ---",
              paste("Error generando resumen:", e$message)
            )
          })
          
        } else {
          report_lines <- c(
            report_lines,
            "--- ANÁLISIS DESeq2 ---",
            "Estado: No ejecutado"
          )
        }
        
        report_lines <- c(
          report_lines,
          " ========================================",
    "NOTA: Este reporte es generado con fines de investigación.",
          "No debe usarse para diagnóstico clínico.",
          "========================================"
        )
        
        log_event(
          user = "demo_user",
          action = "download_report_txt",
          detail = paste("genes:", nrow(stored_data$counts),
                         "muestras:",ncol(stored_data$counts))
        )
        
        # ESCRITURA SEGURA
        writeLines(report_lines, con = file)
        
        # LOG
        message("✅ Reporte TXT generado exitosamente")
      }
    )
    
    # ============================================
    # DESCARGAR CSV (SAFE - FIX DEL CRASH)
    # ============================================
    
    output$download_csv <- downloadHandler(
      
      filename = function() {
        paste0("resultados_deseq2_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")
      },
      
      content = function(file) {
        
        # VALIDACIÓN CRÍTICA
        req(logged_in())
        req(stored_data$deseq)
        req(stored_data$deseq$results)
        
        tryCatch({
          
          # Copiar datos a variable temporal (evita bloqueo)
          results_copy <- stored_data$deseq$results
          
          # Asegurar que gene_id esté como columna
          if (!"gene_id" %in% colnames(results_copy)) {
            results_copy$gene_id <- rownames(results_copy)
          }
          
          # ESCRITURA SEGURA con manejo explícito de conexión
          con <- file(file, open = "wt")
          on.exit(close(con), add = TRUE)
          
          write.csv(results_copy, con, row.names = FALSE)
          
          # LOG
          message("✅ CSV exportado exitosamente: ", nrow(results_copy), " genes")
          
        }, error = function(e) {
          
          # Fallback: escribir error en archivo
          cat("Error generando CSV:", e$message, file = file)
          
          showNotification(
            paste("Error al exportar CSV:", e$message),
            type = "error",
            duration = 10
          )
        })
      }
    )
    
  })
}