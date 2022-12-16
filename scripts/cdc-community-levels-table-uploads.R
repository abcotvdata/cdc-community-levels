library(tidyverse)
library(stringr)


download.file("https://data.cdc.gov/api/views/3nnm-4jni/rows.csv?accessType=DOWNLOAD", "cdc_data.csv")
cdcdata_today <- read.csv("cdc_data.csv")

max_date <- max(as.Date(cdcdata_today$date_updated, format = "%Y-%m-%d"))

cdc_community_levels_us_df <- cdcdata_today %>% 
  mutate(county_fips = str_pad(county_fips, 6, pad = "0")) %>% 
  mutate(date_updated = as.Date(date_updated, format="%Y-%m-%d")) %>% 
  filter(date_updated == max_date) %>% 
  dplyr::rename(County = `county`,
                State = `state`,
                `Bed Utilization` = `covid_inpatient_bed_utilization`,
                `Hospital Admissions per 100k` = `covid_hospital_admissions_per_100k`,
                `Cases per 100k` = `covid_cases_per_100k`,
                `Community Level` = covid.19_community_level) %>% 
  mutate(color = case_when(`Community Level` == "Low" ~ "#00860c",
                           `Community Level` == "Medium" ~ "#ffba00",
                           `Community Level` == "High" ~ "#be0000",
                           TRUE ~ "N/A")) %>% 
  mutate(name = str_replace(County, " County", ""))

write.csv(cdc_community_levels_us_df, "cdc_community_levels_us_df.csv", row.names = FALSE)

cdc_community_levels_ca_df <- cdc_community_levels_us_df %>% 
  filter(State == "California")

write.csv(cdc_community_levels_us_df, "cdc_community_levels_ca_df.csv", row.names = FALSE)
