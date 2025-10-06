library(tinytest)
library(datareportR)

# Basic checks ----
# Test that rmd is saved in a directory if the directory exists
iris = datasets::iris

render_data_report(
  df_input = iris,
  save_rmd_dir = getwd(),
  save_report_dir = getwd()
)

expect_true(file.exists("data_report.Rmd"))
file.remove("data_report.Rmd")

# Try rendering for a directory that doesn't exist
expect_error(
  render_data_report(
    df_input = iris,
    save_rmd_dir = getwd(),
    save_report_dir = "output/"
  ),
  pattern = "Directory to save output HTML"
)

# Custom checks for saving the Rmd ----
# Try a custom save_rmd_file path
data_report_custom_dir = paste0(getwd(), "/data_report_custom/")
dir.create(data_report_custom_dir)
render_data_report(
  df_input = iris,
  save_rmd_dir = data_report_custom_dir,
  save_report_dir = getwd(),
  save_rmd_file = paste0(data_report_custom_dir, "data_report.Rmd")
)

expect_true(file.exists("data_report_custom/data_report.Rmd"))
file.remove("data_report_custom/data_report.Rmd")

# Try a custom save_rmd_file path in a directory that doesn't exist
expect_error(
  render_data_report(
  df_input = iris,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/fake_dir/data_report_custom.Rmd")
  )
)

# Try a custom save_rmd_file path without a file extension
render_data_report(
  df_input = iris,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/data_report_custom")
)

expect_true(file.exists("data_report_custom.Rmd"))
file.remove("data_report_custom.Rmd")

# Custom checks for saving the report ----
# Try a custom save_report_file path
render_data_report(
  df_input = iris,
  save_rmd_dir = getwd(),
  save_report_dir = data_report_custom_dir,
  save_report_file = paste0(data_report_custom_dir, "/data_report_custom2.html")
)

expect_true(file.exists("data_report_custom/data_report_custom2.html"))
Sys.sleep(1) # create slight lag to avoid permission errors
file.remove("data_report_custom/data_report_custom2.html")


# Try a custom save_report_file path in a directory that doesn't exist
expect_error(
  render_data_report(
  df_input = iris,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  save_rmd_file = paste0(getwd(), "/fake_dir/data_report_custom.html")
  )
)

# Try a custom save_report_file path without a file extension
render_data_report(
  df_input = iris,
  save_rmd_dir = NULL,
  save_report_file = paste0(getwd(), "/data_report")
)

expect_true(file.exists("data_report.html"))
Sys.sleep(1)
file.remove("data_report.html")

unlink(data_report_custom_dir, recursive = TRUE)
