dashboard_server <- function(input, output, session, rv) {
  
  # ======================
  # Base de datos (lazy)
  # ======================
  con <- NULL
  
  observeEvent(TRUE, {
    con <<- db_connect()
    session$onSessionEnded(function() {
      if (!is.null(con)) DBI::dbDisconnect(con)
    })
  }, once = TRUE)
  
  # ======================
  # Estado mínimo
  # ======================
  rv$data_loaded <- FALSE
  rv$analysis_done <- FALSE
  rv$demo_mode <- FALSE
  
  # ======================
  # Contraste lógico
  # ======================
  
  global_state <- reactive({
    if (isTRUE(rv$demo_mode)) {
      "DEMO"
    } else if (!isTRUE(rv$data_loaded)) {
      "INICIAL"
    } else if (!isTRUE(rv$analysis_done)) {
      "DATOS_CARGADOS"
    } else if (!has_contrast() || !can_run_deseq_diff()) {
      "EXPLORATORIO"
    } else {
      "DIFERENCIAL"
    }
  })
  
  has_contrast <- reactive({
    req(rv$coldata)
    length(unique(rv$coldata$condition)) >= 2
  })
  
  has_degs <- reactive({
    req(rv$deseq$results)
    any(rv$deseq$results$padj < 0.05, na.rm = TRUE)
  })
  
  low_replication <- reactive({
    req(rv$coldata)
    any(table(rv$coldata$condition) < 2)
  })
  
  can_run_deseq_diff <- reactive({
    req(rv$coldata)
    all(table(rv$coldata$condition) >= 2)
  })
  
  # ======================
  # Carga de datos
  # ======================
  observeEvent(input$load_data_btn, {
    
    message("▶ BOTÓN PRESIONADO")
    
    req(input$data_file)
    
    data <- csv_counts_handler(input$data_file$datapath)
    
    rv$counts   <- data
    rv$data_loaded <- TRUE
    
    message("▶ DATOS CARGADOS")
  })
  
  observe({
    req(rv$data_loaded)
    req(!isTRUE(rv$demo_mode))
    
    samples <- colnames(rv$counts$data)
    
    conds <- sapply(samples, function(s) {
      input[[paste0("cond_", s)]]
    })
    
    req(all(!is.null(conds)))
    
    rv$coldata <- data.frame(
      condition = factor(conds),
      row.names = samples
    )
  })
  
  output$data_clean_summary <- renderText({
    req(rv$data_loaded)
    
    paste0(
      "✔ Datos cargados correctamente\n",
      "Genes: ", nrow(rv$counts$data), "\n",
      "Muestras: ", ncol(rv$counts$data)
    )
  })
  
  observeEvent(input$reset_btn, {
    
    rv$data_loaded <- FALSE
    rv$analysis_done <- FALSE
    rv$demo_mode <- FALSE
    
    rv$counts <- NULL
    rv$coldata <- NULL
    rv$deseq <- NULL
    
    message("Estado reiniciado")
    
    
  })
  # ======================
  # DESeq2 (bajo demanda)
  # ======================
  observeEvent(input$run_deseq_btn, {
    
    req(rv$data_loaded, rv$coldata)
    
    n_levels <- length(unique(rv$coldata$condition))
    min_reps <- min(table(rv$coldata$condition))
    
    if (n_levels < 2 || min_reps < 2) {
      design_formula <- ~ 1
      message("ℹ Ejecutando DESeq en modo exploratorio (~1)")
    } else {
      design_formula <- ~ condition
      message("✔ Ejecutando DESeq con contraste válido")
    }
    
    if (isTRUE(rv$demo_mode)) {
      desing_formula <- ~ condition
    } else if (can_run_deseq_diff()) 
    {desing_formula <- ~ condition} else {
        desing_formula <- ~ 1
      }
    
    
    dds <- deseq_prepare(
      counts  = rv$counts$data,
      coldata = rv$coldata,
      design  = design_formula
    )
    
    rv$deseq <- deseq_analysis(dds)
    rv$analysis_done <- TRUE
  })
  
    
    observeEvent(input$load_demo_btn, {
      
      rv$counts <- NULL
      rv$coldata <- NULL
      rv$deseq <- NULL
      rv$analysis_done <- FALSE
      
      message("▶ DEMO AIRWAY ACTIVADA")
      
      airway <- readRDS("data/airway.rds")
      
      counts <- assay(airway)
      counts <- round(counts)
      
      
      rv$counts <- list(data = counts)
      rv$coldata <- data.frame(condition = factor(colData(airway)$dex,
                                                  levels = c("untrt", "trt")),
                               row.names = colnames(counts))
      
      
      rv$data_loaded <- TRUE
      rv$demo_mode <- TRUE
      rv$analysis_done <- FALSE
      
      
    })
  
  
  output$analysis_status <- renderText({
    req(rv$analysis_done)
    "✔ Análisis DESeq2 completado correctamente"
  })
  
  output$condition_ui <- renderUI({
    req(rv$data_loaded)
    
    # ======================
    # MODO DEMO
    # ======================
    if (isTRUE(rv$demo_mode)) {
      
      tagList(
        helpText("Demo Airway (DESeq2): condiciones experimentales predefinidas."),
        tableOutput("demo_conditions")
      )
      
      # ======================
      # MODO USUARIO
      # ======================
    } else {
      
      samples <- colnames(rv$counts$data)
      
      tagList(
        helpText("Asigne una condición por muestra (mínimo 2 condiciones para contraste)."),
        lapply(samples, function(s) {
          selectInput(
            inputId = paste0("cond_", s),
            label   = s,
            choices = c("A", "B"),
            selected = "A"
          )
        })
      )
    }
  })
  
  output$global_state_header <- renderUI({
   req(global_state())
    
    div(
      style = "display: incline-block; font-size: 12px; margin-left: 10px;",
      paste("Estado:", global_state())
    )
    
  })
  
  output$global_state_footer <- renderUI({
    state <- global_state()
    
    msg <- switch(
      state,
      "DEMO" = "Modo DEMO – Dataset Airway (DESeq2)",
      "INICIAL" = "Esperando carga de datos",
      "DATOS_CARGADOS" = "Datos cargados – configure condiciones",
      "EXPLORATORIO" = "Modo exploratorio (~1) – resultados no inferenciales",
      "DIFERENCIAL" = "Análisis diferencial activo"
    )
    
    tagList(
      tags$span(msg),
      tags$span(style = "float:right;",
                "MontelibanoGen · Exploratory Release"
      )
    )
  })
  
  output$demo_conditions <- renderTable({
    req(rv$demo_mode, rv$coldata)
    data.frame(
      Sample    = rownames(rv$coldata),
      Condition = rv$coldata$condition
    )
  })
  
  output$qc_info <- renderText({
    req(rv$data_loaded)
    
    if (isTRUE(rv$demo_mode)) {
      "Demo Airway (DESeq2): dataset canónico con replicación completa."
    } else if (!has_contrast()) {
      "Modo exploratorio (~1): PCA y QC habilitados."
    } else if (!can_run_deseq_diff()) {
      "Contraste detectado con replicación insuficiente."
    } else {
      "Contraste activo: análisis diferencial completo."
    }
  })
  
  # ======================
  # UI diferencial (condicional)
  # ======================
  output$differential_ui <- renderUI({
    req(rv$analysis_done)
    
    if (!can_run_deseq_diff()) {
      box(
        title = "Análisis diferencial",
        status = "warning",
        "Modo exploratorio (~1): solo PCA y QC disponibles."
      )
      
    } else {
      tagList(
        box(
          width = 6,
          title = "MA plot",
          plotOutput("plot_ma")
        ),
        box(
          width = 6,
          title = "Volcano plot",
          plotOutput("plot_volcano")
        )
      )
    }
  })
  
  # ======================
  # Persistencia
  # ======================
  observeEvent(rv$analysis_done, {
    
    req(con, rv$deseq)
    
    if (isTRUE(rv$demo_mode)) {
      message("ℹ Demo mode: resultados no persistidos")
      return()
    }
    
    if (!is.null(rv$deseq$results) &&
        inherits(rv$deseq$results, "DESeqResults")) {
      
      save_results(
        con     = con,
        results = as.data.frame(rv$deseq$results),
        meta    = rv$coldata
      )
    }
  })
  
  # ======================
  # Visualización
  # ======================
  
  output$plot_pca <- renderPlot({
    
    if (isTRUE(rv$demo_mode)) {
      mat <- log2(rv$counts$data + 1)
      pca <- prcomp(t(mat), stale = TRUE)
      
      plot(
        pca$x[,1], pca$x[,2],
        col = as.numeric(rv$coldata$condition),
        pch = 19,
        xlab = "PC1",
        ylab = "PC2",
        main = "PCA (Demo Airway - ligero)"
      )
    } else {
    
    req(rv$deseq$dds)
    
    vsd <- DESeq2::varianceStabilizingTransformation(rv$deseq$dds, blind = FALSE)
    
    DESeq2::plotPCA(vsd, intgroup = "condition")}
  })
  
  output$plot_volcano <- renderPlot({
    req(can_run_deseq_diff())
    plot_volcano(rv$deseq)
  })
  
  output$plot_ma <- renderPlot({
    req(can_run_deseq_diff())
    plot_ma(rv$deseq)
  })
  
}