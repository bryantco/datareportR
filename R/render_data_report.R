#' Title
#'
#' @param df_input data.frame or tibble. Input dataset to generate the summary report on.
#' @param save_report_to_disk boolean. TRUE to save the .Rmd file to disk at the specified 
#' `save_rmd_dir` directory, FALSE to remove the generated .Rmd file at runtime.
#' @param save_rmd_dir character. Path to save the .Rmd file to disk.
#' @param save_html_dir character. Path to save the .html output file to disk.
#' @param include_skim boolean. TRUE to include the data summary with skimr::skim() in the 
#' report. FALSE to exclude.
#' @param include_diffdf boolean. TRUE to include the data diff with diffdf::diffdf() in the report.
#' FALSE to exclude.
#' @param df_input_old data.frame or tibble. Old input dataset to call diffdf::diffdf() on. 
#'
#' @importFrom skimr skim
#' @importFrom diffdf diffdf
#' @importFrom rmarkdown render
#'
#' @returns An output RMarkdown report with the data summary.
#' @export
#'
render_data_report = function(
  df_input = NULL,
  save_report_to_disk = TRUE,
  df_input_old = NULL,
  save_rmd_dir = getwd(),
  save_html_dir = getwd(),
  include_skim = TRUE,
  include_diffdf = TRUE
) {

  # Sanity checks ----
  # Check that directories exist; throw a warning if not
  if (save_report_to_disk & !dir.exists(save_rmd_dir)) { 
    stop ("Directory to save rmd to does not exist. Please create the directory.") 
  }

  if (!dir.exists(save_html_dir)) { stop ("Directory to save output HTML report to does not exist. Please create the directory.")  }

  # Check that at least one of include_skim and include_diffdf is TRUE
  if (!(include_skim | include_diffdf)) { stop("At least one of include_skim and include_diffdf must be specified for a non-empty report. Respecify these parameters.") }
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

  report_setup_code = c(
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
    "```"
  )

  if (include_skim) {
    report_skimr_code = c(
      "",
      "# Data Overview",
      "```{r}",
      "skimr::skim(df_input, .data_name = df_input_name)",
      "```"
    )
  } else {
    report_skimr_code = c("")
  }

  if (include_diffdf) {
    report_diffdf_code = c(
      "",
      "# Summary of Changes from Previous Version",
      "```{r}",
      "diffdf::diffdf(df_input, df_input_old)",
      "```"
    )
  } else {
    report_diffdf_code = c("")
  }

  report_body_code = c(
    report_setup_code,
    report_skimr_code,
    report_diffdf_code
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
    output_dir = save_html_dir,
    params = list(
      df_input = df_input,
      df_input_name = df_input_name,
      df_input_old = df_input_old
    )
  )

  # Save report to disk or delete according to save_to_disk bool ----
  if (!save_report_to_disk) {
    report_removed = file.remove(rmd_path)
    stopifnot(report_removed)
  }
}