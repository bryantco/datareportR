library(datareportR)
library(bench)
library(tictoc)
library(tidyverse)

set.seed(12345)

# Helper function to create a simple data.frame of the specified dimensions
create_df = function(rows, cols) {
  as.data.frame(setNames(
    replicate(cols, runif(rows, 1, 1000), simplify = FALSE),
    paste0("col", 1:cols)))
}

timestamp = format(Sys.time(), "%Y%m%d_%H%M%S")
filename = paste0("output/log_benchmark_", timestamp, ".txt")
sink(filename)

# Run 6 data sizes by number of rows and number of features with 2 replicates
tictoc::tic()

results = press(
  rows = c(1000, 10000, 100000),
  cols = c(50, 300),
  rep = 1:10,
  {
    dat = create_df(rows, cols)
    dat_old = create_df(rows, cols)
    bench::mark(
      datareportR::render_data_report(
        df_input = dat,
        save_report_to_disk = FALSE,
        df_input_old = dat_old,
        save_rmd_dir = getwd(),
        save_html_dir = getwd(),
        include_skim = TRUE,
        include_diffdf = TRUE
      )
    )
  }
)

tictoc::toc()

results_plot = results %>%
  as_tibble() %>%
  select(rows, cols, rep, total_time) %>%
  group_by(rows, cols) %>%
  summarize(mean_time = mean(total_time))

ggplot(results_plot) + 
  geom_point(aes(x = rows, y = mean_time, color = as.factor(cols))) + 
  geom_line(aes(x = rows, y = mean_time, color = as.factor(cols))) + 
  labs(color = "Number of columns")
 
ggsave("_assets/benchmark_results.png", width = 10, height = 6)