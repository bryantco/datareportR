# Overview

Data is often not perfect. A traditional analyst workflow is to work through a 
dataset column subset by column subset and investigating flaws and inacurracies
such as outliers and missing values. `datareportR` attempts to simplify this process by 
providing the analyst information about all the columns in a dataset a single glance. 

It consists of a small but powerful function, `render_data_report()`, which takes 
input data and outputs a "data report" as an HTML document. Under the hood, it uses the powerful
`skimr::skim()` and `diffdf::diffdf()` functions to create the report. See below for an example on the 
`nycflights13` dataset.

# Install

# Examples

# Benchmarking