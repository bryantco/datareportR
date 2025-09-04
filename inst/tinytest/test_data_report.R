library(tinytest)

flights = nycflights13::flights


render_data_report(
  df_input = flights,
  save_report_to_disk = TRUE,
  save_rmd_dir = getwd(),
  df_input_old = flights
)

report_rmd_removed = file.remove("data_report.Rmd")
expect_true(report_rmd_removed)

report_html_removed = file.remove("data_report.html")
expect_true(report_html_removed)