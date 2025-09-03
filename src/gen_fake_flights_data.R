# Setup ------------------------------------------------------------------------
if (interactive()) {
  setwd(gsub("src(.*)?", "", rstudioapi::getSourceEditorContext()$path)) 
} 

set.seed(12345)

library(nycflights13)
library(usethis)

flights = nycflights13::flights

flights_permuted = flights[sample(nrow(flights)), ]

usethis::use_data(flights_permuted, overwrite = TRUE)
