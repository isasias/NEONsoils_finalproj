# Script is to download the periodic soil data and to calculate soil extractable inorganic N and net N transformation rates from NEON soil KCl extracts
# This script then merges the bulk soil chemistry data with the output of the neonNTrans package for one soil dataframe
# 10/23/2021


## Loading packages
library(neonUtilities)
library(devtools) 
#install_github("NEONScience/NEON-Nitrogen-Transformations/neonNTrans", dependencies=TRUE)  
library(neonNTrans)  
library(lubridate)

## def.calc.ntrans function in package neonNTrans (1)  joins variables across tables 
## (2) calculate blank-corrected inorganic N concentrations in KCl extracts 
## (3) conver from N concentrations in extracts (mg N/L) to soil extractable N concentrations (ug N/g dry soil), and
## (4) calculate net N mineralization and nitrification rates using initial and incubated core pairs


## Downloading data from NEON data portal
soildata <- loadByProduct(dpID = "DP1.10086.001",
                           site = c("JERC", "UNDE", "KONA", "DELA", "DCFS", "NIWO", "WREF", "BONA"),
                           startdate="2019-06", enddate="2019-10",
                           package = "basic", check.size = FALSE)

list2env(soildata, .GlobalEnv)

#### Bulk soil chemistry data ####
soil_chemistry <- sls_soilChemistry %>%
  filter(plotType == "tower", 
         cnIsotopeQF == "OK")
View(soil_chemistry)

## Saving the desired data
write.csv(soil_chemistry, "data_raw/soil_chemistry.csv")


#### Calculating N transformations with ef.calc.ntrans function in package neonNTrans ####
out <- def.calc.ntrans(kclInt = soilNdata$ntr_internalLab, 
                       kclIntBlank = soilNdata$ntr_internalLabBlanks, 
                       kclExt = soilNdata$ntr_externalLab, 
                       soilMoist = soilNdata$sls_soilMoisture, 
                       dropAmmoniumFlags = "blanks exceed sample value", 
                       dropNitrateFlags = "blanks exceed sample value" )

## returns a list of dataframes.
## data_summary succinctly provides inorganic N concentrations in ug N g-1 dry soil plus net N transformation rates in ug N g-1 d-1 for incubated samples 
## *IF BOTH INITIAL AND FINAL CORES ARE AVAILABLE*
## all_data is included so that end users can see all of the calculations that went in to the final estimates
## other data frames are summaries of which records were excluded due to conditions, flags, or missing soil moisture values

## Looking at output
names(out)
View(out$all_data)
View(out$data_summary)

## Converting named list to create an 'environment' containing all list components as objects
list2env(out, .GlobalEnv)

soilNinorganic <- data_summary

## Writing/saving the data_summary
write.csv(soilNinorganic, "data_raw/soil_inorganicN.csv")

#### Merging soil chemistry and inorganic N for one soil dataframe ####
totalsoil <- left_join(soil_chemistry,
                       soilNinorganic,
                       by = c("sampleID", "collectDate")) %>%
  select(domainID, siteID, plotID, sampleID, collectDate, d15N, nitrogenPercent, organicCPercent, CNratio, 35:39)
View(totalsoil)
## Changing dates to Julian day
totalsoil$JulianDay <- yday(totalsoil$collectDate)

## Writing/saving the dataframe
write.csv(totalsoil, "data_raw/totalsoildata.csv")
