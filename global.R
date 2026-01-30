# ======================
# DEPENDENCIAS
# ======================
library(shiny)
library(shinyjs)
library(DBI)
library(RSQLite)
library(shinydashboard)
library(DESeq2)
library(dplyr)
library(ggplot2)

# ======================
# CONFIGURACIÓN
# ======================
options(shiny.maxRequestSize = 50 * 1024^2)

# ======================
# FUNCIONES AUXILIARES (PRIMERO)
# ======================
source("R/utils/logging.R")
source("R/auth/demo_auth.R")
source("R/components/footer_ui.R")
source("R/components/modal_etica.R")
source("R/components/modal_evaluacion.R")

# Datos
source("R/gendata/gendata_models.R")
source("R/gendata/handlers/csv_counts_handler.R")

# DESeq
source("R/deseq/deseq_prepare.R")
source("R/deseq/deseq_analysis.R")

# Persistencia
source("R/persistence/db_connect.R")
source("R/persistence/results_repository.R")

# Visualización
source("R/visualization/plots.R")

# ======================
# UI/SERVER (AL FINAL)
# ======================
source("R/visualization/dashboard_ui.R")
source("R/visualization/dashboard_server.R")