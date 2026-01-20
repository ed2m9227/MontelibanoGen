CREATE TABLE IF NOT EXISTS genomics.deseq_results (
  result_id SERIAL PRIMARY KEY,
  analysis_id INTEGER REFERENCES genomics.deseq_analysis(analysis_id),
  gene_id TEXT NOT NULL,

  base_mean DOUBLE PRECISION,
  log2FoldChange DOUBLE PRECISION,
  lfcSE DOUBLE PRECISION,
  stat DOUBLE PRECISION,
  pvalue DOUBLE PRECISION,
  padj DOUBLE PRECISION
);