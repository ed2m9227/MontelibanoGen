CREATE SCHEMA IF NOT EXISTS genomics;

CREATE TABLE IF NOT EXISTS genomics.deseq_analysis (
    analysis_id      UUID PRIMARY KEY,
    created_at       TIMESTAMP DEFAULT now(),
    organism         TEXT NOT NULL,
    assay_type       TEXT NOT NULL,
    design_formula   TEXT NOT NULL,
    contrast         TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS genomics.deseq_results (
    id               BIGSERIAL PRIMARY KEY,
    analysis_id      UUID REFERENCES genomics.deseq_analysis(analysis_id),
    gene_id          TEXT NOT NULL,
    base_mean        DOUBLE PRECISION,
    log2_fc          DOUBLE PRECISION,
    lfc_se           DOUBLE PRECISION,
    stat             DOUBLE PRECISION,
    pvalue           DOUBLE PRECISION,
    padj             DOUBLE PRECISION
);