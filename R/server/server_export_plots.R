server_export_plots <- function(input, output, rv) {
  
  output$download_volcano <- downloadHandler(
    filename = function() {
      paste0("volcano_", Sys.Date(), ".png")
    },
    content = function(file) {
      p <- plot_volcano(rv$results)
      ggsave(file, p, width = 7, height = 5, dpi = 300)
      rm(p)
      gc()
    }
  )
  
  output$download_ma <- downloadHandler(
    filename = function() {
      paste0("ma_", Sys.Date(), ".png")
    },
    content = function(file) {
      p <- plot_ma(rv$results)
      ggsave(file, p, width = 7, height = 5, dpi = 300)
      rm(p)
      gc()
    }
  )
  
}
