# Downloading the plant trait data to associated with the sites selected for our project
# Creating a merged dataframe with the total soil data


## Loading packages
library(neonUtilities)
library(dplyr)

## Reading in saved soils data from my file system
soildata <- read.csv("data_raw/totalsoildata.csv")
View(soildata)

## Reading in plant trait data from the NEON data portal
rootdata <- loadByProduct(dpID="DP1.10067.001",
                           site =  c("JERC", "UNDE", "KONA", "DELA", "DCFS", "NIWO", "WREF", "BONA"),
                           package="basic", check.size=FALSE)
names(rootdata)
list2env(rootdata, .GlobalEnv)

## Creating plant N d15N dataframe to merge with total soil data for comprehensive data frame
View(bbc_rootChemistry)

plantN <- cfc_carbonNitrogen %>%
  filter(plotType == "tower", isotopeAccuracyQF =="OK") %>%
  filter(!is.na(d15N))
View(plantN)

## Creating complete dataframe with root d15N and all soil data

plantNsummary <- plantN %>%
  select(siteID, plotID, d15N) %>%
  group_by(siteID, plotID) %>%
  summarise(d15Nroot = mean(d15N)) %>%
  ungroup()
View(plantNsummary)

soild15Nsummary <- soildata %>%
  select(2:4, 7) %>%
  na.omit() %>%
  group_by(domainID, siteID, plotID) %>%
  summarise(d15Nsoil = mean(d15N))
View(soild15Nsummary)  

merged15Ndata <- inner_join(soild15Nsummary, 
                       plantNsummary,
                       by = c("siteID", "plotID"))
View(merged15Ndata)

calcd15Ndata <- merged15Ndata %>%
  mutate(delta = d15Nsoil-d15Nroot)
View(calcd15Ndata)

## soil summary minus the d15N
remainingsoilsummary <- soildata %>%
  select(2:4, 8:15) %>%
  na.omit() %>%
  group_by(domainID, siteID, plotID) %>%
  summarise_all(mean)
View(remainingsoilsummary)  

## combining both summary data frames
fulldata <- full_join(calcd15Ndata, 
                      remainingsoilsummary,
                      by = c("domainID", "siteID", "plotID"))
View(fulldata)

## Writing/saving dataframe
write.csv(fulldata, "data_raw/fulldataforisotopeenrichment.csv")
