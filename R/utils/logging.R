log_event <- function(user, action, detail = NULL) {
  
  if (is.null(user) || user == "") {
    user <- "anonymous"
  }
  
  if (is.null(detail)) {
    detail <- NA
  }
  
  df <- data.frame(
    user = as.character(user),
    action = as.character(action),
    detail = as.character(detail),
    timestamp = Sys.time(),
    stringsAsFactors = FALSE
  )
  
  if (!exists("app_logs", envir = .GlobalEnv)) {
    
    assign("app_logs", df, envir = .GlobalEnv)
    
  } else {
    
    assign(
      "app_logs",
      rbind(get("app_logs", envir = .GlobalEnv), df),
      envir = .GlobalEnv
    )
    
  }
  
  invisible(TRUE)
}
