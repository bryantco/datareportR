# Setup ------------------------------------------------------------------------
if (interactive()) {
  setwd(gsub("src(.*)?", "", rstudioapi::getSourceEditorContext()$path)) 
} 

library(rmarkdown)

rmarkdown::render(
  input = "data_report.Rmd"
)