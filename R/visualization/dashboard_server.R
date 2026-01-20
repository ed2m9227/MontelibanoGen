library(shiny)
library(DBI)
library(DT)

dashboard_server <- function(input, output, session,
                             logged_in,
                             stored_data,
                             con) {
  
  logout_pending <- reactiveVal(FALSE)
  
  output$logged_in <- reactive({
    logged_in() 
  })
  outputOptions(output, "logged_in", suspendWhenHidden = FALSE)
  
  # ===========================================================================
  # LOGIN HANDLER
  # ===========================================================================
  
  observeEvent(input$login_btn, {
    
    #Obten credenciales
    user_input <- input$user
    pass_input <- input$pass
    
    #Validar de que estén vacíos
    if (is.null(user_input) || is.null(pass_input)) {
      showNotification("Por favor ingrese usuario y contraseña", type = "error")
    }
    
    if (user_input == "" || pass_input == "") {
      showNotification("Por favor ingrese usuario y contraseña", type = "error")
      return()
    }
    
    res <- check_demo_login(input$user, input$pass) 
    
    if (res$ok){
      
      logged_in(TRUE)
      stored_data$user_role <- res$role
      stored_data$current_user <- user_input
      
      log_event(
        user = input$user,
        action = "login",
        detail = res$role
      )
      
      show_evaluation_modal()
      
    } else {
      showNotification("Credenciales inválidas", type = "error")
    }
  }
  )
  
  # ===========================================================================
  # LLAMADA A MÓDULOS
  # ===========================================================================
  upload_module_server("up", logged_in, stored_data)
  
  statistical_module_server("stat", stored_data = stored_data, logged_in = logged_in)
  
  visualization_module_server("viz", stored_data = stored_data, logged_in = logged_in)
  
  reports_module_server("rep", logged_in, stored_data)

  
  # ===========================================================================
  # VALUE BOXES - NOMBRES CORREGIDOS
  # ===========================================================================
  
  output$vb_samples <- renderValueBox({
    n_samples <- if (!is.null(stored_data$counts)) {
      ncol(stored_data$counts)
    } else {
      0
    }
    
    valueBox(
      value = n_samples,
      subtitle = "Muestras",
      icon = icon("vials"),
      color = "blue"
    )
  })
  
  output$vb_genes <- renderValueBox({
    n_genes <- if (!is.null(stored_data$counts)) {
      nrow(stored_data$counts)
    } else {
      0
    }
    
    valueBox(
      value = format(n_genes, big.mark = ","),
      subtitle = "Genes",
      icon = icon("dna"),
      color = "green"
    )
  })
  
  output$vb_analyses <- renderValueBox({
    n_analyses <- tryCatch({
      dbGetQuery(con, "SELECT COUNT(*) FROM genomics.deseq_analysis")[[1]]
    }, error = function(e) {
      0
    })
    
    valueBox(
      value = n_analyses,
      subtitle = "Análisis DESeq2",
      icon = icon("chart-line"),
      color = "purple"
    )
  })
  
  output$vb_status <- renderValueBox({
    status_text <- if (!is.null(stored_data$deseq)) {
      "Análisis Completo"
    } else if (!is.null(stored_data$dds)) {
      "Datos Cargados"
    } else {
      "Sin Datos"
    }
    
    status_color <- if (!is.null(stored_data$deseq)) {
      "green"
    } else if (!is.null(stored_data$dds)) {
      "yellow"
    } else {
      "red"
    }
    
    valueBox(
      value = status_text,
      subtitle = "Estado del Sistema",
      icon = icon("info-circle"),
      color = status_color
    )
  })
  
  
  # ===========================================================================
  # LOGOUT
  # ===========================================================================
  observeEvent(input$logout_btn, {
    if (!logout_pending()) {
      
      # PRIMER CLICK → LIMPIEZA
      log_event(
        user = stored_data$current_user,
        action = "logout_prepare"
      )
      
      # Limpieza suave
      stored_data$counts <- NULL
      stored_data$dds <- NULL
      stored_data$deseq <- NULL
      
      logout_pending(TRUE)
      
      showNotification(
        "Datos limpiados. Presione nuevamente para cerrar sesión.",
        type = "message",
        duration = 4
      )
      
    } else {
      
      # SEGUNDO CLICK → CIERRE REAL
      log_event(
        user = stored_data$current_user,
        action = "logout"
      )
      
      logged_in(FALSE)
      
      stored_data$current_user <- NULL
      stored_data$user_role <- NULL
      
      logout_pending(FALSE)
      
      showNotification("Sesión cerrada", type = "warning")
    }
  })


# ===========================================================================
# MODAL ÉTICO - ACTIVADO POR LINK EN FOOTER
# ===========================================================================
modal_etica_server(input, output, session)
  
}