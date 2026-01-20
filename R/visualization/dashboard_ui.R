dashboard_ui <- function() {
  
  source("R/components/footer_ui.R", local = TRUE)
  
  dashboardPage(
    
    dashboardHeader(
      title = "MontelibanoGen",
      titleWidth = 250
    ),
    
    dashboardSidebar(
      width = 250,
      
      sidebarMenu(
        id = "sidebar",
        
        menuItem("Plataforma", tabName = "main", icon = icon("layer-group")),
        menuItem("Carga de Datos", tabName = "upload", icon = icon("upload")),
        menuItem("Estadística", tabName = "stat", icon = icon("calculator")),
        menuItem("Visualización", tabName = "viz", icon = icon("chart-bar")),
        menuItem("Reportes", tabName = "reports", icon = icon("file-pdf")),
        menuItem("Salir", tabName = "logout", icon = icon("sign-out-alt"))
      )
    ),
    
    dashboardBody(
      
      # =======================
      # CSS GLOBAL
      # =======================
      tags$style(HTML("
        .login-overlay {
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          z-index: 9999;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .login-box {
          margin-top: 12vh;
        }

        .content-wrapper {
          padding-bottom: 60px !important;
        }

        .main-footer-custom {
          position: fixed;
          bottom: 0;
          left: 250px;
          right: 0;
          padding: 10px 15px;
          background-color: #ecf0f5;
          border-top: 1px solid #d2d6de;
          z-index: 1031;
          text-align: center;
          font-size: 12px;
          color: #444;
        }

        #value-boxes .small-box .inner h3 {
          font-size: 24px;
        }

        #value-boxes .small-box .inner p {
          font-size: 14px !important;
        }
      ")),
      
      # =======================
      # LOGIN OVERLAY (FULL PAGE)
      # =======================
      conditionalPanel(
        condition = "output.logged_in === false",
        
        tags$div(
          class = "login-overlay",
          
          fluidRow(
            column(
              width = 4,
              offset = 4,
              
              div(
                class = "login-box",
                
                box(
                  title = "MontelibanoGen - Acceso",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  
                  HTML("<p style='text-align: center;'><i class='fa fa-dna fa-3x' style='color: #3c8dbc;'></i></p>"),
                  
                  textInput("user", "Usuario", placeholder = "demo_admin"),
                  passwordInput("pass", "Contraseña", placeholder = "demo123"),
                  
                  actionButton(
                    "login_btn",
                    "Ingresar",
                    class = "btn-primary btn-block",
                    icon = icon("sign-in-alt")
                  ),
                  
                  hr(),
                  
                  helpText(
                    HTML("<b>Credenciales demo:</b><br>
                         Usuario: <code>demo_admin</code><br>
                         Contraseña: <code>demo123</code>")
                  ),
                  
                  helpText(
                    HTML("<i class='fa fa-graduation-cap'></i> Modo evaluación académica")
                  )
                )
              )
            )
          )
        )
      ),
      
      # =======================
      # DASHBOARD REAL
      # =======================
      tabItems(
        
        tabItem(
          tabName = "main",
          
          fluidRow(
            box(
              width = 12,
              title = "Bienvenido a MontelibanoGen",
              status = "primary",
              solidHeader = TRUE,
              
              HTML("
                <h4>Plataforma de Análisis Genómico</h4>
                <p>Aplicación web integrada para análisis transcriptómico diferencial (RNA-seq)</p>

                <h5>Flujo de trabajo:</h5>
                <ol>
                  <li><b>Carga de Datos:</b> Suba CSV o use dataset airway</li>
                  <li><b>Estadística:</b> Ejecute análisis DESeq2</li>
                  <li><b>Visualización:</b> Explore gráficos (PCA, MA, Volcano)</li>
                  <li><b>Reportes:</b> Genere informes descargables</li>
                  <li><b>Limpiar datos:</b> Poner datos en cero y/o salir</li>
                </ol>
              ")
            )
          ),
          
          div(
            id = "value-boxes",
            fluidRow(
              valueBoxOutput("vb_samples", width = 3),
              valueBoxOutput("vb_genes", width = 3),
              valueBoxOutput("vb_analyses", width = 3),
              valueBoxOutput("vb_status", width = 3)
            )
          )
        ),
        
        tabItem(tabName = "upload", upload_module_ui("up")),
        tabItem(tabName = "stat", statistical_module_ui("stat")),
        tabItem(tabName = "viz", visualization_module_ui("viz")),
        tabItem(tabName = "reports", reports_module_ui("rep")),
        
        tabItem(
          tabName = "logout",
          fluidRow(
            box(
              width = 12,
              title = "Cerrar Sesión",
              status = "danger",
              solidHeader = TRUE,
              actionButton("logout_btn", "Salir de la Plataforma",
                           class = "btn-danger btn-lg",
                           icon = icon("sign-out-alt"))
            )
          )
        )
      ),
      
      footer_ui()
    )
  )
}
