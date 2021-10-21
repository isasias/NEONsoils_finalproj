# Making plots of the nutrient data from our selected sites

## Loading packages
library(dbplyr)
library(ggplot2)

## Reading in data
soil_chemistry <- readr::read_csv("data_raw/site_chemistry.csv")
View(soil_chemistry)
soil_inorganicN <- readr::read_csv("data_raw/site_inorganicN.csv")
View(soil_inorganicN)

soil_nutrients <- readr::read_csv("data_raw/total_site_nutrients.csv")
View(soil_nutrients)

## Plot of CN by site
boxplot(CNratio~siteID,
        data=soil_chemistry,
        xlab="Site", ylab="CN Ratio")

## Plot of soil N conc (%N) by site
boxplot(nitrogenPercent~siteID,
        data=soil_chemistry,
        xlab="Site", ylab="Nitrogen %")

## Plot of soil C conc (%C) by site
boxplot(organicCPercent~siteID,
        data=soil_chemistry,
        xlab="Site", ylab="Carbon %")

## Plot of d15N by site
boxplot(d15N~siteID,
        data=soil_chemistry,
        subset= cnIsotopeQF == "OK",
        xlab="Site", ylab="d15N")

## Plot of ammonium by site
boxplot(kclAmmoniumNConc~siteID,
        data=soil_inorganicN,
        xlab="Site", ylab="NH4-N mg L")

## Plot of NO3-/NO2- by site
boxplot(kclNitrateNitriteNConc~siteID,
        data=soil_inorganicN,
        xlab="Site", ylab="NH4-N mg L")


## Plot of CN by Npercent
plot(CNratio ~ nitrogenPercent,
     data = soil_chemistry)

## Plot of d15N by Npercent
plot(d15N ~ nitrogenPercent,
     data = soil_chemistry)

## Plot of d15N by Cpercent
plot(d15N ~ organicCPercent,
     data = soil_chemistry)

## Plot of d15N by CN
plot(d15N ~ CNratio,
     data = soil_chemistry)

## Plot of d15N by nitrate/nitrite
plot(d15N ~ kclNitrateNitriteNConc,
     data = soil_nutrients)

## Plot of d15N by ammonium
plot(d15N ~ kclAmmoniumNConc,
     data = soil_nutrients)

## Plot of nitrate by ammonium  
plot(kclNitrateNitriteNConc ~ kclAmmoniumNConc,
     data = soil_nutrients)

## Plot of ammonium by CN ratio  
plot(kclAmmoniumNConc ~ CNratio,
     data = soil_nutrients)

## Plot of nitrate by CN ratio  
plot(kclNitrateNitriteNConc ~ CNratio,
     data = soil_nutrients)

## Plot of ammonium by %N  
plot(kclAmmoniumNConc ~ nitrogenPercent,
     data = soil_nutrients)

## Plot of nitrate by %N  
plot(kclNitrateNitriteNConc ~ nitrogenPercent,
     data = soil_nutrients)

