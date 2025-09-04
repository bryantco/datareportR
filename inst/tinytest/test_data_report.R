flights = nycflights13::flights
# flights_permuted = datareportR::flights_permuted

render_data_report(
  df_input = flights,
  save_report_to_disk = TRUE,
  save_rmd_dir = getwd(),
  df_input_old = flights
)

tinytest::expect_equal(1+1, 2)