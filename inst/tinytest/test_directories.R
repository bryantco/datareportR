library(tinytest)
library(datareportR)

# Basic checks ----
# Test that rmd is saved in a directory if the directory exists
flights = nycflights13::flights

render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd()
)

expect_true(file.exists("data_report.Rmd"))

# Try rendering for a directory that doesn't exist
expect_error(
  render_data_report(
    df_input = flights,
    save_rmd_dir = getwd(),
    save_report_dir = "output/"
  ),
  pattern = "Directory to save output HTML"
)

# Custom checks for saving the Rmd ----
# Try a custom save_rmd_file path
render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/data_report_custom.Rmd")
)

expect_true(file.exists("data_report_custom.Rmd"))
file.remove("data_report_custom.Rmd")

# Try a custom save_rmd_file path in a directory that doesn't exist
expect_error(
  render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/fake_dir/data_report_custom.Rmd")
  )
)

# Try a custom save_rmd_file path without a file extension
render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/data_report_custom")
)

expect_true(file.exists("data_report_custom.Rmd"))

# Custom checks for saving the report ----
# Try a custom save_report_file path
render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_report_file = paste0(getwd(), "/data_report_custom2.html")
)

expect_true(file.exists("data_report_custom2.html"))

# Try a custom save_report_file path in a directory that doesn't exist
expect_error(
  render_data_report(
  df_input = flights,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/fake_dir/data_report_custom.html")
  )
)

# Try a custom save_report_file path without a file extension
render_data_report(
  df_input = flights,
  save_report_file = paste0(getwd(), "/data_report")
)

expect_true(file.exists("data_report.html"))

# Remove all files ----
report_rmd_removed = file.remove("data_report.Rmd")
expect_true(report_rmd_removed)

report_html_removed = file.remove("data_report.html")
expect_true(report_html_removed)

report_html_custom2_removed = file.remove("data_report_custom2.html")
expect_true(report_html_custom2_removed)

report_rmd_custom_removed = file.remove("data_report_custom.Rmd")
expect_true(report_rmd_custom_removed)

report_html_custom_removed = file.remove("data_report_custom.html")
expect_true(report_html_custom_removed)
