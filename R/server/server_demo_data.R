server_demo_data <- function(input, rv) {
  
  observeEvent(input$load_demo, {
    
    counts <- load_airway()
    
    dds <- prepare_deseq(counts)
    dds <- run_deseq(dds)
    
    results <- extract_results(dds)
    
    rv$results <- results
    
    rm(dds, counts)
    gc()
  })
  
}
