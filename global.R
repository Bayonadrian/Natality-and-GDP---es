library(shiny)
library(bslib)
library(htmltools)
library(plotly)
library(lubridate)
library(tidyr)
library(dplyr)
library(ggplot2)
library(purrr)

unpivot_data <- function(df) {
  df %>%
    pivot_longer(
      cols = matches("^X?20[0-9]{2}$"),
      names_to = "year",
      values_to = "value"
    ) %>%
    mutate(
      year = as.numeric(gsub("^X", "", year)),
      value = as.numeric(value)
    ) %>%
    filter(year >= 2012, year <= 2023)
}

replacement_rate_continents <- read.csv("Data/replacement_rate_continents.csv") %>%
  rename(
    year = time,
    value = Babies.per.woman
  ) %>%
  mutate(year = as.numeric(year), value = as.numeric(value)) %>%
  filter(year >= 2012, year <= 2023)

replacement_rate_countries <- read.csv("Data/replacement_rate_countries.csv") %>%
  rename(value = Babies.per.women) %>%
  mutate(year = as.numeric(year), value = as.numeric(value)) %>%
  filter(year >= 2012, year <= 2023)

gdp <- unpivot_data(read.csv("Data/gdp_pcap.csv"))

corruption <- unpivot_data(read.csv("Data/corruption_perception_index_cpi.csv"))

replacement_rate_countries_gdp <- replacement_rate_countries %>%
  left_join(
    gdp,
    by = c("geo", "year"),
    suffix = c("_natality", "_gdp")
  )

corruption_gdp <- corruption %>%
  inner_join(
    gdp,
    by = c("geo", "year"),
    suffix = c("_corruption", "_gdp")
  )