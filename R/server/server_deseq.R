server_deseq <- function(input, rv, con) {
  
  observeEvent(input$run_deseq, {
    
    req(input$counts_file)
    
    counts <- load_counts(input$counts_file)
    
    dds <- prepare_deseq(counts)
    dds <- run_deseq(dds)
    
    results <- extract_results(dds)
    
    rv$results <- results
    
    save_results(con, results)
    
    rm(dds, counts)
    gc()
  })
  
}
