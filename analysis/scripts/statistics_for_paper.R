# statistics for paper - to be sourced and inserted into the text
library(readr)
library(dplyr)

#read some pre-processed data text/csv file from the /data directory
syn <- read_csv2(here::here("analysis/data/head_celltypes_syn_matrix.csv"))

# extract some data -------------------------

max_PRC <- syn |>
  select(PRC) |>
  max()
