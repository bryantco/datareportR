# Overview

Data is often not perfect. A traditional analyst workflow is to work through a 
dataset column subset by column subset and investigating flaws and inacurracies
such as outliers and missing values. **datareportR** attempts to simplify this process by 
providing the analyst information about all the columns in a dataset a single glance. 

It consists of a small but powerful function, `render_data_report()`, which takes 
input data and outputs a "data report" as an HTML document. Under the hood, it uses the powerful
`skimr::skim()` and `diffdf::diffdf()` functions to create the report. See below for an example on the 
`nycflights13` dataset.

# Install

**datareportR** can be installed from this repository:

`remotes::install_github("bryantco/datareportR")`

# Examples

See the below animation for a scroll-through of the data report generated on the 
flights ![dataset](https://github.com/tidyverse/nycflights13) from `nycflights13`.

![](https://github.com/bryantco/datareportR/blob/main/_assets/data_report.gif)

# Benchmarking

**datareportR** is intended for use on *medium-sized* data (both in terms of rows
and columns). For a graph that compares the time to render the report, see below. The
x-axis is number of rows (1,000, 10,000, and 100,000), and the colors represent the 
numer of features (columns). On average, across a small set of 10 runs, it took a maximum
overall of nearly 2 minutes to render the report for a dataset with 100,000 rows and 300 features.

![](https://github.com/bryantco/datareportR/blob/main/_assets/benchmark_results.png)