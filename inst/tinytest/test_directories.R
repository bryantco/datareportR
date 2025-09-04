# Test 
# if (interactive()) {
#   setwd(gsub("src(.*)?", "", rstudioapi::getSourceEditorContext()$path)) 
# } 

library(nycflights13)
library(tinytest)

# Test that rmd is saved in a directory if the directory exists
flights = nycflights13::flights
flights_permuted = datareportR::flights_permuted

render_data_report(
  df_input = flights,
  save_report_to_disk = TRUE,
  save_rmd_dir = getwd(),
  df_input_old = flights_permuted
)

expect_true(file.exists("data_report.Rmd"))
