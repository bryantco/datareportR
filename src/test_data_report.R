# Setup ------------------------------------------------------------------------
if (interactive()) {
  setwd(gsub("src(.*)?", "", rstudioapi::getSourceEditorContext()$path)) 
} 

library(rmarkdown)
library(nycflights13)

source("R/render_data_report.R")

flights = nycflights13::flights
load("data/flights_permuted.rda")

render_data_report(
  df_input = flights,
  save_report_to_disk = TRUE,
  df_input_old = flights_permuted
)