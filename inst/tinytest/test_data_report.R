library(tinytest)
library(datareportR)

iris = datasets::iris

datareportR::render_data_report(
  df_input = iris,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  include_skim = TRUE,
  output_format = "html"
)

report_rmd_removed = file.remove("data_report.Rmd")
expect_true(report_rmd_removed)

report_html_removed = file.remove("data_report.html")
expect_true(report_html_removed)