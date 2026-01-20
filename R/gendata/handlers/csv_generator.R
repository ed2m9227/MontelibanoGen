counts_ok <- data.frame(
  gene_id = c("BRCA1", "TP53", "EGFR", "MYC"),
  control_1 = c(120, 130, 300, 280),
  control_2 = c(90, 85, 160, 155),
  treated_1 = c(90, 85, 160, 155),
  treated_2 = c(600, 620, 900, 880)
)

write.csv(
  counts_ok,
  "data/raw/counts_test.csv",
  row.names = FALSE
)