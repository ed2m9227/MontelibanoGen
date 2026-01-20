demo_users <- data.frame(
  user = c("demo_admin", "demo_investigator"),
  password = c("demo123", "demo123"),
  role = c("admin", "analyst"),
  stringsAsFactors = FALSE
)

check_demo_login <- function(user, pass) {
  row <- demo_users[demo_users$user == user & demo_users$password == pass, ]
  if (nrow(row) == 1) {
    return(list(ok = TRUE, role =  row$role))
  }
  list(ok = FALSE)
}