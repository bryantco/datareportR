library(tinytest)
library(datareportR)

flights = nycflights13::flights

datareportR::render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_html_dir = getwd(),
  include_skim = TRUE
)

report_rmd_removed = file.remove("data_report.Rmd")
expect_true(report_rmd_removed)

# report_html_removed = file.remove("../../output/data_report.html")
# expect_true(report_html_removed)