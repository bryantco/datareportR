# Setup ------------------------------------------------------------------------
if (interactive()) {
  setwd(gsub("src(.*)?", "", rstudioapi::getSourceEditorContext()$path)) 
} 

library(rmarkdown)
library(nycflights13)

source("R/render_data_report.R")

flights = nycflights13::flights

render_data_report(df_input = flights)