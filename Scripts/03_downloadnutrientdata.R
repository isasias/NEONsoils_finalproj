# Downloading the distributed soil data for 2019-06 to 2019-10 for capstone project
# filtered for sites that have tower data to pair with CO2 data

## Loading packages
library(neonUtilities)
library(dplyr)

## Reading in data from the NEON data portal
soil_data <- loadByProduct(dpID="DP1.10086.001",
                           startdate="2019-06", enddate="2019-10",
                           package="basic", check.size=F)
names(soil_data)
list2env(soil_data, .GlobalEnv)

## Bulk chemistry data
site_chemistry <- sls_soilChemistry %>%
  filter(plotType == "tower")
View(site_chemistry)

write.csv(site_chemistry, "data_raw/site_chemistry.csv")

## Inorganic N data
site_inorganicNdata <- ntr_externalLab %>%
  filter(plotID %in% site_chemistry$plotID)
View(site_inorganicNdata)
site_inorganicNmeta <- ntr_internalLab %>%
  filter(plotID %in% site_chemistry$plotID) %>%
  select(sampleID, soilFreshMass, kclVolume)
View(site_inorganicNmeta)

site_inorganicN <- merge(site_inorganicNdata,
                         site_inorganicNmeta,
                         by = c("sampleID") ) %>%
  filter(ammoniumNQF == "OK" & nitrateNitriteNQF == "OK")

write.csv(site_inorganicN, "data_raw/site_inorganicN.csv")

## Merged dataframe
by = sampleID


total_site_nutrients <- full_join(site_inorganicN, site_chemistry, by = "sampleID")
View(total_site_nutrients)

write.csv(total_site_nutrients, "data_raw/total_site_nutrients.csv")

# site_selection$domainID
# unique(site_selection$domainID)
# unique(site_selection$siteID)