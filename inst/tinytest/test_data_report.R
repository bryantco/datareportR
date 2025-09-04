library(tinytest)

flights = nycflights13::flights
flights_permuted = datareportR::flights_permuted


datareportR::render_data_report(
  df_input = flights,
  save_report_to_disk = TRUE,
  df_input_old = flights_permuted,
  save_rmd_dir = getwd(),
  save_html_dir = "../../output/",
  include_skim = TRUE,
  include_diffdf = TRUE
)

report_rmd_removed = file.remove("data_report.Rmd")
expect_true(report_rmd_removed)

# report_html_removed = file.remove("../../output/data_report.html")
# expect_true(report_html_removed)