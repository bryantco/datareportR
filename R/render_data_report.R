library(tidyverse)

render_data_report = function(
  df_input
) {

  df_input_name = deparse(substitute(df_input))

  report_header_code = c(
    "---",
    'title: "Data Summary Report"',
    'date: "`r Sys.Date()`"',
    "output: html_document",
    "knit:",
    "  opts_chunk:",
    "    echo: FALSE",
    "    message: FALSE", 
    "    warning: FALSE",
    "    error: FALSE",
    "    include: TRUE",
    "params:",
    "  df_input: NULL",
    "  df_input_name: NULL",
    "---",
    ""
  )

  report_body_code = c(
    "```{r, setup}",
    "library(skimr)",
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

  rmarkdown::render(
    input = "data_report.Rmd",
    params = list(
      df_input = df_input,
      df_input_name = df_input_name
    )
  )
}