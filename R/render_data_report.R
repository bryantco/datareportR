#' Title
#'
#' @param df_input data.frame or tibble. Input dataset to generate the summary report on.
#' @param df_input_old data.frame or tibble. Old input dataset to call diffdf::diffdf() on. 
#' @param save_rmd_dir character. Path to save the .Rmd file to. Defaults to the current
#' working directory. If NULL, does not save the report to disk.
#' @param save_report_dir character. Path to save the report to. Defaults to the current
#' working directory.
#' @param save_rmd_file character. Path to save the .Rmd file to. Can be either a 
#' file name (e.g., "data_report") or a file path. If a file path is specified, 
#' it must be consistent with save_rmd_dir, if save_rmd_dir is specified. If 
#' there is no file extension in the file path, automatically appends the .Rmd
#' extension.
#' @param save_report_file character. Path to save the report to. Can be either a 
#' file name (e.g., "data_report") or a file path. If a file path is specified, 
#' it must be consistent with save_report_dir, if save_report_dir is specified. If 
#' there is no file extension in the file path, automatically appends an extension.
#' @param include_skim boolean. TRUE to include the data summary with skimr::skim() in the 
#' report. FALSE to exclude.
#' @param include_diffdf boolean. TRUE to include the data diff with diffdf::diffdf() in the report.
#' FALSE to exclude. If df_input_old is not specified, automatically set to FALSE.
#' @param output_format character. Output format of the data report. Defaults to "html." So far, only "pdf" and "html"
#' are supported.
#' @importFrom skimr skim
#' @importFrom diffdf diffdf
#' @importFrom rmarkdown render
#'
#' @returns An output RMarkdown report with the data summary.
#' @export
#'
render_data_report = function(
  df_input,
  df_input_old = NULL,
  save_rmd_dir = NULL,
  save_report_dir = NULL,
  save_rmd_file = NULL,
  save_report_file = NULL,
  include_skim = TRUE,
  include_diffdf = TRUE,
  output_format = "html"
) {

  # Sanity checks ----
  # Infer include_diffdf as FALSE if no input dataset is specified
  # Otherwise, that parameter defaults to TRUE, which raises the "Old data to diff not specified"
  # error below.
  if (is.null(df_input_old)) { include_diffdf = FALSE }

  # Can't have a null df_input
  if (is.null(df_input)) {
    stop("Input dataframe not found. Please update the df_input argument to point it to the data you want to summarize.")
  }

  # Either include_skim or include_diffdf must be TRUE
  if (!include_skim & !include_diffdf) {
    stop("Either include_skim or include_diffdf must be TRUE. Please re-specify these parameters.")
  }

  # Old df must be specified if include_skim = TRUE
  if (is.null(df_input_old) & include_diffdf) {
    stop("Old data to diff not specified. Please update the df_input_old argument to point it to the old dataset or change include_diffdf to FALSE.")
  }
  
  # Check that directories exist; throw a warning if not
  # One of save_report_dir and save_report_file must be specified
  if (is.null(save_report_dir) & is.null(save_report_file)) {
    stop("At least one of save_report_dir and save_report_file must be specified. Please check these arguments.")
  }

  if (!is.null(save_rmd_dir)) {
    if(!dir.exists(save_rmd_dir)) { stop ("Directory to save rmd to does not exist. Please create the directory.")  }
  }

  if (!is.null(save_report_dir)) {
    if (!dir.exists(save_report_dir)) { stop ("Directory to save output report to does not exist. Please create the directory.")  }
  }

  df_input_name = deparse(substitute(df_input))

  # Output format must be "html" or "pdf"
  output_format = tolower(output_format)
  if (!output_format %in% c("html", "pdf")) {
    stop("Output format not supported. Please specify output_format as 'html' or 'pdf'.")
  }

  # Generate RMarkdown report ----
  output_format_for_header = paste0(output_format, "_document")
  report_header_code = c(
    "---",
    'title: "Data Summary Report"',
    'date: "`r Sys.Date()`"',
    paste0("output: ", output_format_for_header),
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
    
    skim_fun = "skim"
    # if pdf, remove sparklines
    if (output_format == "pdf") { skim_fun = "skim_without_charts"}
    
    report_skimr_code = c(
      "",
      "# Data Overview",
      "```{r}",
      paste0("skimr::", skim_fun, "(df_input, .data_name = df_input_name)"),
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
  # if save_rmd_dir is NULL, create temp directory for the Rmd as the current
  # directory; otherwise, use save_rmd_dir
  if (is.null(save_rmd_dir)) { 
    rmd_path = paste0(getwd(), "/", "data_report.Rmd")
  } else {
    rmd_path = paste0(save_rmd_dir, "/", "data_report.Rmd")
  }

  # if save_rmd_file is a full file path, prioritize the file path
  if (!is.null(save_rmd_file)) {
    # check that the directory exists
    dir = dirname(save_rmd_file)
    if (!dir.exists(dir)) { stop("Directory specified in save_rmd_file does not exist. Please create it or update save_rmd_file.") }
    
    # check that the directory is consistent with save_rmd_dir if specified
    if (!is.null(save_rmd_dir)) {
      stopifnot(dir == dirname(rmd_path))
    }

    # if no file extension, automatically append an extension
    grep_rmd = "\\.(Rmd)$"
    if(!grepl(grep_rmd, save_rmd_file)) {
      save_rmd_file = paste0(save_rmd_file, ".Rmd")
    }

    rmd_path = save_rmd_file
  }

  # Throw a warning to the user if the data report already exists
  if (file.exists(rmd_path)) {
    warning("Existing copy of data_report.Rmd being overwritten.")
  }

  writeLines(report_all_code, rmd_path)

# perform the same checks for the output report
if (is.null(save_report_dir)) { 
  output_path = paste0(getwd(), "/", "data_report.", output_format)
} else {
  output_path = paste0(save_report_dir, "/", "data_report.", output_format)
}
  
if (!is.null(save_report_file)) {
  # check that the directory exists
  dir = dirname(save_report_file)
  if (!dir.exists(dir)) { stop("Directory specified in save_report_file does not exist. Please create it or update save_report_file.") }
  
  # check that the directory is consistent with save_report_dir if specified
  if (!is.null(save_report_dir)) {
    stopifnot(dir == dirname(output_path))
  }
  
  output_path = save_report_file
  # no need to fix the file extension since rmarkdown::render() will automatically
  # add one if needed
}

  # Render report ----
  rmarkdown::render(
    input = rmd_path,
    output_file = output_path,
    params = list(
      df_input = df_input,
      df_input_name = df_input_name,
      df_input_old = df_input_old
    )
  )

  # Save report to disk or delete ----
  save_report_to_disk = !is.null(save_rmd_dir)
  if (!save_report_to_disk) {
    report_removed = file.remove(rmd_path)
    stopifnot(report_removed)
  }
}