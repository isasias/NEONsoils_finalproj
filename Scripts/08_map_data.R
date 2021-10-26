# Creating .csv of site names, domain name, and locations to make the map

# Loading packages
library(dplyr)

# Loading data
metadata <- read.csv("data_raw/NEON_Field_Site_Metadata_edited.csv") # BONA coords edited for mapping
domains <- read.csv("data_raw/sites_domains.csv")

# Creating one dataframe with our sites and locations to make the map
site_meta <- metadata %>%
  filter(field_site_id %in% domains$siteID) %>%
  select(field_site_id, field_site_name, field_longitude, field_latitude, 
         field_mean_annual_temperature_C, field_mean_annual_precipitation_mm) %>%
  rename(siteID = field_site_id) 

site_locations <- left_join(site_meta, domains, by = "siteID")

str(site_locations)
View(site_locations)

# Saving dataframe for plotting!
write.csv(site_locations, "data_raw/site_locations.csv")
