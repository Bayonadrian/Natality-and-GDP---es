library(shiny)
library(bslib)
library(htmltools)
library(plotly)
library(lubridate)
library(tidyr)
library(dplyr)
library(ggplot2)

unpivot_data <- function(df) {
  df %>%
    pivot_longer(
      cols = starts_with("X"),
      names_to = "year",
      values_to = "value"
    ) %>%
    mutate(
      year = as.numeric(sub("^X", "", year))
    ) %>%
    filter(year >= 2012, year <= 2023)
}

cast_date <- function(df) {
  data <- df %>%
    mutate(year = ymd(paste0(year, "-01-01")))
  
  return(data)
}

replacement_rate_continents= read.csv("Data/replacement_rate_continents.csv") %>% 
  rename(
    year = time,
    value = Babies.per.woman
  ) %>% 
  filter(year <= 2023 & year >= 2012)

replacement_rate_countries= read.csv("Data/replacement_rate_countries.csv") %>% 
  rename(
    value = Babies.per.women
  ) %>% 
  filter(year <= 2023 & year >= 2012)

gdp= unpivot_data(read.csv("Data/gdp_pcap.csv"))

replacement_rate_countries_gdp= left_join(replacement_rate_countries, gdp, by= c("geo", "year"))
