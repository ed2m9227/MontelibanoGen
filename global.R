# =========================
# DEPENDENCIAS
# =========================
library(shiny)
library(shinyjs)
library(DBI)
library(RSQLite)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)
library(readr)
library(readxl)
library(jsonlite)
library(sodium)
library(rmarkdown)
library(knitr)
library(shinydashboard)

# Bioconductor
library(Biostrings)
library(VariantAnnotation)
library(DESeq2)
library(biomaRt)
library(rtracklayer)
library(Rsamtools)

# ======================
# Utils / Core
# ======================
source("R/gendata/gendata_models.R")
source("R/gendata/handlers/csv_counts_handler.R")
source("R/components/modal_etica.R")
source("R/utils/logging.R")
source("R/auth/demo_auth.R")
source("R/components/modal_evaluacion.R")

# ======================
# DESeq
# ======================
source("R/deseq/demo_airway_loader.R")
source("R/deseq/deseq_prepare.R")
source("R/deseq/deseq_analysis.R")
source("R/deseq/deseq_qc.R")

# ======================
# Persistence
# ======================
source("R/persistence/db_connect.R")
source("R/persistence/results_repository.R")

# ======================
# Visualization 
# ======================
source("R/visualization/plots.R")
source("R/visualization/dashboard_ui.R")
source("R/visualization/dashboard_server.R")


# ======================
# Shiny modules
# ======================
invisible(
  lapply(
    list.files("R/shiny/modules",
               full.names = TRUE),
    source
  )
)


# ======================
# DB conection
# ======================
con <- db_connect()
stopifnot(dbIsValid(con))