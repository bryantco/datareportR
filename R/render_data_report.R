render_data_report = function(
  df_input
) {

  df_input_name = deparse(substitute(df_input))

  rmarkdown::render(
    input = "data_report.Rmd",
    params = list(
      df_input = df_input,
      df_input_name = df_input_name
    )
  )
}