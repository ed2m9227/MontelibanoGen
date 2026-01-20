upload_module_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h4("Carga de Datos"),
    fileInput(
      ns("file"),
      "Subir archivo CSV de conteos",
      accept = ".csv"
    ), 
    actionButton(
      ns("load_demo"),
      "Cargar dataset demo (airway)", 
      icon = icon("flask"),
      class = "btn-info"
    ), 
    hr(),
    verbatimTextOutput(ns("status")),
    hr(),
    h5("Vista previa de datos:"),
    DT::dataTableOutput(ns("preview"))
  )
}

upload_module_server <- function(id, logged_in, stored_data) {
  moduleServer(id, function(input, output, session) {
    
    
    
    # =========================================================================
    # CSV UPLOAD - SOLO CARGA, NO EJECUTA DESeq2
    # =========================================================================
    observeEvent(input$file, {
      
      # Guard simple
      if (inherits(logged_in, "reactiveVal")) {
        req(logged_in())
      }
      
      req(input$file)
      
      counts <- tryCatch(
        read.csv(
          input$file$datapath,
          row.names = 1,
          check.names = FALSE
        ),
        error = function(e) {
          showNotification("No se pudo leer el CSV correctamente", type = "error")
          return(NULL)
        }
      )
      
      # Validación mínima
      if (is.null(counts)) return()
      
      if (nrow(counts) == 0) {
        showNotification("El archivo no tiene genes", type = "error")
        return(NULL)
      }
      
      if (ncol(counts) < 2) {
        showNotification("Debe haber al menos dos muestras", type = "error")
        return(NULL)
      }
      
      # Construir coldata
      source("R/deseq/coldata_builder.R")
      coldata <- build_coldata(counts)
      
      # Crear DESeqDataSet SIN EJECUTAR ANÁLISIS
      dds <- prepare_deseq_dataset(
        counts = counts,
        coldata = coldata
      )
      
      # ======================================================================
      # ALMACENAR EN ESTADO GLOBAL - SIN DESeq2
      # ======================================================================
      stored_data$counts <- counts
      stored_data$coldata <- coldata
      stored_data$dds <- dds
      stored_data$deseq <- NULL  # Resetear resultados previos
      
      log_event(
        user = "user_demo",
        action = "load_demo_airway",
        detail = paste(
          "genes: ", nrow(counts),
          "muestras", ncol(counts)
        )
      )
      
      output$status <- renderText({
        paste(
          "✅ Conteos cargados:",
          nrow(counts), "genes /",
          ncol(counts), "muestras\n",
          "⚠️  Ejecute DESeq2 en la pestaña 'Estadística'"
        )
      })
      
      message("✅ Counts, coldata y DESeqDataSet creados correctamente")
      
    }, ignoreInit = TRUE)
    
    # =========================================================================
    # AIRWAY DEMO - SOLO CARGA, NO EJECUTA DESeq2
    # =========================================================================
    observeEvent(input$load_demo, {
      
      tryCatch({
        library(airway)
        data(airway)
        
        counts <- assay(airway)
        coldata <- as.data.frame(colData(airway))
        coldata$dex <- factor(coldata$dex)
        
        # Crear DESeqDataSet SIN EJECUTAR
        dds <- DESeqDataSetFromMatrix(
          countData = counts,
          colData = coldata,
          design = ~ dex
        )
        
        # ALMACENAR SIN ANÁLISIS
        stored_data$counts <- counts
        stored_data$coldata <- coldata
        stored_data$dds <- dds
        stored_data$deseq <- NULL  # Resetear resultados previos
        
        output$status <- renderText(
          "✅ Dataset airway cargado correctamente\n⚠️ Ejecute DESeq2 en la pestaña 'Estadística'"
        )
        
      }, error = function(e) {
        showNotification(paste("Error al cargar airway:", e$message), type = "error")
      })
    })
    
    # =========================================================================
    # PREVIEW TABLE
    # =========================================================================
    output$preview <- DT::renderDataTable({
      req(stored_data$counts)
      
      DT::datatable(
        head(stored_data$counts, 50),
        options = list(
          scrollX = TRUE,
          pageLength = 10
        )
      )
    })
  })
}
