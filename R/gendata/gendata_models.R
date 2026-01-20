# =========================================================
# GenData model
# Contrato formal del dato biológico
# =========================================================

GenData <- function(
    data,
    data_type,
    organism = NA_character_,
    assay_type = NA_character_,
    metadata = list(),
    source_file = NA_character_
) {
  
  stopifnot(!is.null(data))
  stopifnot(is.character(data_type))
  
  structure(
    list(
      data = data,                 # objeto principal
      data_type = data_type,       # csv_counts, fasta, fastq, etc
      organism = organism,
      assay_type = assay_type,     # rnaseq, chipseq, etc
      metadata = metadata,         # sample info, conditions
      source_file = source_file
    ),
    class = "GenData"
  )
}

print.GenData <- function(x, ...) {
  cat("GenData object\n")
  cat("Type:", x$data_type, "\n")
  cat("Organism:", x$organism, "\n")
  cat("Assay:", x$assay_type, "\n")
}
