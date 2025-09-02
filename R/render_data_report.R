library(tidyverse)
library(assertr)

render_data_report = function(
  df_input = NULL,
  save_report_to_disk = TRUE
) {

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
    "---",
    ""
  )

  report_body_code = c(
    "```{r setup, include=FALSE}",
    "library(skimr)",
    "library(tidyverse)",
    "knitr::opts_chunk$set(",
    "  echo = FALSE,",
    "  message = FALSE,",
    "  warning = FALSE,",
    "  error = FALSE,",
    "  include = TRUE",
    ")",
    "df_input = params$df_input",
    "df_input_name = params$df_input_name",
    "```",
    "",
    "```{r}",
    "df_input %>%",
    "  skim(.data_name = df_input_name)",
    "```"
  )

  report_all_code = c(report_header_code, report_body_code)
  writeLines(report_all_code, "data_report.Rmd")

  # Render report ----
  rmarkdown::render(
    input = "data_report.Rmd",
    params = list(
      df_input = df_input,
      df_input_name = df_input_name
    )
  )

  # Save report to disk or delete according to save_to_disk bool ----
  if (!save_report_to_disk) {
    report_removed = file.remove("data_report.Rmd")
    assertr::verify(report_removed, function(x) x == TRUE)
  }
}