# Setup ------------------------------------------------------------------------
library(datareportR)
set.seed(12345)

iris = datasets::iris
iris_permuted = iris
iris_permuted$Species <- sample(iris$Species)

render_data_report(
  df_input = iris,
  save_report_to_disk = TRUE,
  df_input_old = iris_permuted,
  save_rmd_dir = getwd(),
  save_html_dir = getwd(),
  include_skim = TRUE,
  include_diffdf = TRUE
)