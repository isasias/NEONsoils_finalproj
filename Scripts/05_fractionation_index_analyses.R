# Using fractionation index to investigate relationship with soil CNratio and inorganic N 

## Loading packages
library(dplyr)
library(ggplot2)

## Reading in dataframe created in code loadingplanttraits.R that include the d15N for roots, soil and the isotope enrichment labeled "delta"
full15Ndata <- read.csv("data_raw/fulldataforisotopeenrichment.csv")
View(full15Ndata)

## Exploratory plots

### Boxplot of isotope enrichment/delta by site
deltaplot <- full15Ndata %>% 
  ggplot(aes(siteID, delta)) +
  geom_boxplot() +
  xlab("Site") +
  ylab("soil 15N isotope enrichment")
deltaplot

### Plot of isotope enrichment/delta by soil d15N
ggplot(data = full15Ndata,
       aes(d15Nsoil, delta)) +
  geom_point() +
  xlab("Soil d15N") +
  ylab("soil 15N isotope enrichment")

### Plot of soil d15N by root d15N
ggplot(data = full15Ndata,
       aes(d15Nroot, d15Nsoil, shape = siteID)) +
  geom_point() +
  xlab("Root d15N") +
  ylab("soil d15N")

### Plot of soil d15N by CN
ggplot(data = full15Ndata,
       aes(CNratio, d15Nsoil, color = siteID)) +
  geom_point() +
  xlab("CN Ratio") +
  ylab("soil d15N")

### Plot of isotope enrichment/delta by CNratio
ggplot(data = full15Ndata,
       aes(CNratio, delta)) +
  geom_point() +
  xlab("CN Ratio") +
  ylab("soil 15N isotope enrichment")

### Plot of isotope enrichment/delta by organic C percent
ggplot(data = full15Ndata,
       aes(organicCPercent, delta)) +
  geom_point() +
  xlab("SOC %") +
  ylab("soil 15N isotope enrichment")

### Plot of isotope enrichment/delta by total soil inorganic N
ggplot(data = full15Ndata,
       aes(soilInorganicNugPerGram, delta)) +
  geom_point() +
  xlab("ug inorganic-N g-1 soil") +
  ylab("soil 15N isotope enrichment")

### Plot of isotope enrichment/delta by nitrate-N
ggplot(data = full15Ndata,
       aes(soilNitrateNitriteNugPerGram, delta)) +
  geom_point() +
  xlab("ug NO3-N g-1 soil") +
  ylab("soil 15N isotope enrichment")

### Plot of isotope enrichment/delta by nitrate-N
ggplot(data = full15Ndata,
       aes(soilAmmoniumNugPerGram, delta)) +
  geom_point() +
  xlab("ug NO3-N g-1 soil") +
  ylab("soil 15N isotope enrichment")
