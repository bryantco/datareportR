library(magrittr)
library(assertr)
library(rmarkdown)
library(skimr)
library(diffdf)

render_data_report = function(
  df_input = NULL,
  save_report_to_disk = TRUE,
  save_rmd_dir = getwd(),
  df_input_old = NULL
) {

  # Sanity checks ----
  # Check that directories exist; throw a warning if not
  if (!dir.exists(save_rmd_dir)) { stop ("Error! Directory to save rmd to does not exist. Please create the directory.") }

  df_input_name = deparse(substitute(df_input))

  # Generate RMarkdown report ----
  report_header_code = c(
    "---",
    'title: "Data Summary Report"',
    'date: "`r Sys.Date()`"',
    "output: html_document",
    "params:",
    "  df_input: NULL",
    "  df_input_name: NULL",
    "  df_input_old: NULL",
    "---",
    ""
  )

  report_body_code = c(
    "```{r setup, include=FALSE}",
    "library(skimr)",
    "library(magrittr)",
    "",
    "knitr::opts_chunk$set(",
    "  echo = FALSE,",
    "  message = FALSE,",
    "  warning = FALSE,",
    "  error = FALSE,",
    "  include = TRUE",
    ")",
    "df_input = params$df_input",
    "df_input_name = params$df_input_name",
    "df_input_old = params$df_input_old",
    "```",
    "",
    "# Data Overview",
    "```{r}",
    "df_input %>%",
    "  skim(.data_name = df_input_name)",
    "```",
    "",
    "# Summary of Changes from Previous Version",
    "```{r}",
    "diffdf::diffdf(df_input, df_input_old)",
    "```"
  )

  report_all_code = c(report_header_code, report_body_code)

  # Store temp report on disk ----
  # Throw a warning to the user if the data report already exists
  rmd_path = paste0(save_rmd_dir, "/", "data_report.Rmd")
  if (file.exists(rmd_path)) {
    warning("Existing copy of data_report.Rmd overwritten.")
  }
  writeLines(report_all_code, rmd_path)

  # Render report ----
  rmarkdown::render(
    input = rmd_path,
    params = list(
      df_input = df_input,
      df_input_name = df_input_name,
      df_input_old = df_input_old
    )
  )

  # Save report to disk or delete according to save_to_disk bool ----
  if (!save_report_to_disk) {
    report_removed = file.remove(rmd_path)
    assertr::verify(report_removed, function(x) x == TRUE)
  }
}