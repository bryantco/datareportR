library(tinytest)
library(datareportR)

# Test that rmd is saved in a directory if the directory exists
flights = nycflights13::flights
flights_permuted = datareportR::flights_permuted

render_data_report(
  df_input = flights,
  save_report_to_disk = TRUE,
  df_input_old = flights_permuted,
  save_rmd_dir = "../../data/",
  save_html_dir = "../../data/"
)

# Try rendering for a directory that doesn't exist
expect_error(
  render_data_report(
    df_input = flights,
    save_report_to_disk = TRUE,
    df_input_old = flights_permuted,
    save_rmd_dir = "../../data/",
    save_html_dir = "output/"
  ),
  pattern = "Directory to save output HTML"
)

expect_true(file.exists("../../data/data_report.Rmd"))

report_rmd_removed = file.remove("../../data/data_report.Rmd")
expect_true(report_rmd_removed)

report_html_removed = file.remove("../../data/data_report.html")
expect_true(report_html_removed)
