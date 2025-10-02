library(tinytest)
library(datareportR)

# Test that rmd is saved in a directory if the directory exists
flights = nycflights13::flights

render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd()
)

# Try a custom save_rmd_file path
render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/data_report_custom.Rmd")
)

# Try a custom save_rmd_file path in a directory that doesn't exist
render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/fake_dir/data_report_custom.Rmd")
)

# Try a custom save_rmd_file path without a file extension
render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/data_report_custom")
)

# Try rendering for a directory that doesn't exist
expect_error(
  render_data_report(
    df_input = flights,
    save_rmd_dir = getwd(),
    save_report_dir = "output/"
  ),
  pattern = "Directory to save output HTML"
)

expect_true(file.exists("data_report.Rmd"))

report_rmd_removed = file.remove("data_report.Rmd")
expect_true(report_rmd_removed)

report_html_removed = file.remove("data_report.html")
expect_true(report_html_removed)
