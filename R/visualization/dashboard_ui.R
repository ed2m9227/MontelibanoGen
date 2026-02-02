dashboard_ui <- function() {
  
  shinydashboard::dashboardPage(
    
    # ======================
    # HEADER
    # ======================
    shinydashboard::dashboardHeader(
      title = tagList(
        "MontelibanoGen"
      )
    ),
    
    # ======================
    # SIDEBAR
    # ======================
    shinydashboard::dashboardSidebar(
      shinydashboard::sidebarMenu(
        
        shinydashboard::menuItem(
          "Plataforma",
          tabName = "plataforma",
          icon = icon("home")
        ),
        
        shinydashboard::menuItem(
          "Datos",
          tabName = "data",
          icon = icon("upload")
        ),
        
        shinydashboard::menuItem(
          "Análisis",
          tabName = "analysis",
          icon = icon("flask")
        ),
        
        shinydashboard::menuItem(
          "Resultados",
          tabName = "results",
          icon = icon("chart-line")
        )
      )
    ),
    
    # ======================
    # BODY
    # ======================
    shinydashboard::dashboardBody(
      
      shinyjs::useShinyjs(),
      
      # ===== CSS =====
      tags$head(
        tags$style(HTML("
          #global-footer {
            position: fixed;
            bottom: 0;
            width: 100%;
            background: #f8f8f8;
            border-top: 1px solid #ddd;
            padding: 6px 12px;
            font-size: 12px;
            z-index: 999;
          }

          .content-wrapper {
            padding-bottom: 60px;
          }
        "))
      ),
      
      # ======================
      # TABS
      # ======================
      shinydashboard::tabItems(
        
        # --------------------------------------------------
        # PLATAFORMA
        # --------------------------------------------------
        shinydashboard::tabItem(
          tabName = "plataforma",
          
          fluidRow(
            box(
              width = 12,
              title = "Introducción",
              status = "primary",
              solidHeader = TRUE,
              "Plataforma de análisis genómico orientada a fines académicos e investigativos.
               Permite cargar datos de conteo, ejecutar análisis DESeq2 y visualizar resultados
               de forma interactiva.
              Desarrollado por Eduardo Andrés Martínez M."
            )
          ),
          
          fluidRow(
            box(
              width = 6,
              title = "Uso de la plataforma",
              status = "primary",
              solidHeader = TRUE,
              HTML("
                <ol>
                  <li><strong>Cargar datos</strong> (archivo de conteos o Demo Airway).</li>
                  <li><strong>Asignar condiciones</strong> por muestra.</li>
                  <li><strong>Ejecutar análisis</strong>:
                    <ul>
                      <li>Modo exploratorio (~1): PCA y QC.</li>
                      <li>Modo contraste: MA y Volcano.</li>
                    </ul>
                  </li>
                  <li><strong>Interpretar resultados</strong> según el estado del análisis.</li>
                  <li><strong>Resetear</strong> resultados para nuevo análisis.</li>
                </ol>
                <p><em>Nota:</em> El análisis diferencial requiere al menos dos condiciones
                con replicación suficiente. </p>
              ")
            ),
            
            box(
              width = 6,
              title = "Límites éticos y legales",
              status = "warning",
              solidHeader = TRUE,
              HTML("
                <ul>
                  <li>Uso <strong>exclusivamente educativo e investigativo</strong>.</li>
                  <li>No constituye <strong>diagnóstico clínico</strong>.</li>
                  <li>No sustituye criterio profesional.</li>
                  <li>Los resultados dependen del diseño experimental.</li>
                </ul>
                <p><strong>El usuario es responsable del uso e interpretación.</strong></p>
              ")
            )
          )
        ),
        
        # --------------------------------------------------
        # DATOS
        # --------------------------------------------------
        shinydashboard::tabItem(
          tabName = "data",
          
          fluidRow(
            box(
              width = 6,
              fileInput(
                "data_file",
                "Subir archivo de conteos",
                accept = ".csv"
              )
            ),
            box(
              width = 6,
              actionButton(
                "load_data_btn",
                "Cargar datos"
              )
            ),
            box(
              width = 6,
              actionButton(
                "load_demo_btn",
                "Cargar demo Airway"
              )
            ),
        box(
          width = 6,
          actionButton(
            "reset_btn",
            "Nuevo análisis",
            icon = icon("rotate-left"),
            class = "btn-warning"
          )
          )),
          
          fluidRow(
            box(
              width = 12,
              title = "Definición de condiciones",
              status = "info",
              solidHeader = TRUE,
              uiOutput("condition_ui")
            )
          ),
          
          fluidRow(
            box(
              width = 12,
              textOutput("data_clean_summary")
            )
          )
        ),
        
        # --------------------------------------------------
        # ANÁLISIS
        # --------------------------------------------------
        shinydashboard::tabItem(
          tabName = "analysis",
          
          fluidRow(
            box(
              width = 12,
              actionButton(
                "run_deseq_btn",
                "Ejecutar DESeq2"
              )
            )
          )
        ),
        
        # --------------------------------------------------
        # RESULTADOS
        # --------------------------------------------------
        shinydashboard::tabItem(
          tabName = "results",
          
          fluidRow(
            box(
              width = 12,
              title = "PCA (Control de Calidad)",
              status = "primary",
              solidHeader = TRUE,
              plotOutput("plot_pca", height = "400px")
            )
          ),
          
          fluidRow(
            box(
              width = 12,
              title = "Estado del análisis",
              status = "info",
              solidHeader = TRUE,
              verbatimTextOutput("qc_info")
            )
          ),
          
          fluidRow(
            uiOutput("differential_ui")
          )
        )
      ),
      
      # ======================
      # FOOTER GLOBAL
      # ======================
      div(
        id = "global-footer",
        uiOutput("global_state_footer")
      )
    )
  )
}
