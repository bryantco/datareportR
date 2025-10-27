# datareportR

<!-- badges: start -->
<a href="https://CRAN.R-project.org/package=datareportR"><img src="https://www.r-pkg.org/badges/version/datareportR" class="img-fluid" alt="CRAN version"></a>
<a href="https://bryantco.r-universe.dev"><img src="https://bryantco.r-universe.dev/badges/datareportR" class="img-fluid" alt="R-universe"></a>
<a href="https://github.com/bryantco/datareportR/actions/workflows/r-cmd-check.yml"><img src="https://github.com/bryantco/datareportR/actions/workflows/r-cmd-check.yml/badge.svg" class="img-fluid" alt="GitHub Actions"></a>
<!-- badges: end -->

## Overview

Data often is not perfect. A traditional analyst workflow sees one combing through 
dataset, column subset by column subset, and investigating flaws and inacurracies
such as outliers and missing values. **datareportR** attempts to simplify this manual process by providing the analyst information about all the columns in a dataset a single glance. 

**datareportR** consists of a small but powerful function, `render_data_report()`, which takes 
input data and outputs a "data report" as a pdf or HTML document. Under the hood, it uses the powerful
`skimr::skim()` and `diffdf::diffdf()` functions to create the report. See below for an example on the 
`iris` dataset.

## Usage

See the below screenshots for a the data report generated on the iris dataset, comparing 
it to a permuted version. The function call was as follows:

```r
render_data_report(
  df_input = iris,
  df_input_old = iris_permuted,
  save_rmd_dir = getwd(),
  save_report_dir = getwd(),
  include_skim = TRUE,
  include_diffdf = TRUE,
  output_format = "html"
)
```

![](https://github.com/bryantco/datareportR/blob/main/_assets/data_report_1.PNG)

![](https://github.com/bryantco/datareportR/blob/main/_assets/data_report_2.PNG)

## Install

**datareportR** can be installed from CRAN: 

```r
install.packages("datareportR")
```

You can also install the dev version from my r-universe:

```r
install.packages("datareportR", repos = "https://bryantco.r-universe.dev")
```
## Benchmarking

**datareportR** is intended for use on *medium-sized* data (both in terms of rows
and columns). For a graph that compares the time to render the report, see below. The
x-axis is number of rows (1,000, 10,000, and 100,000), and the colors represent the 
numer of features (columns). On average, across a small set of 10 runs, it took a maximum
overall of nearly 2 minutes to render the report for a dataset with 100,000 rows and 300 features.

In my personal use, I have used the package, with no issues, to create a data report for a dataset topping out at 85 million rows.

Benchmarks were performed on my personal machine, which has 32 GB of RAM. These 
benchmarks are *suggestive*, but the time  to run `datareportR` on your own computer might
be different.

![](https://github.com/bryantco/datareportR/blob/main/_assets/benchmark_results.png)