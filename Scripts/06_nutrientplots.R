# Making plots of the nutrient data from our selected sites

## Loading packages
library(dplyr)
library(ggplot2)

## Reading in data
soildata <- readr::read_csv("data_raw/totalsoildata.csv")
View(soildata)

## Plot of CN by site
CNsiteplot <- soildata %>% 
        ggplot(aes(siteID, CNratio)) +
        geom_boxplot() +
        xlab("Site") +
        ylab("CN ratio")
CNsiteplot

ggsave("figures/CNsiteplot.png")

## Plot of soil N conc (%N) by site
Npercentsiteplot <- soildata %>% 
        ggplot(aes(siteID, nitrogenPercent)) +
        geom_boxplot() +
        xlab("Site") +
        ylab("Soil %N")
Npercentsiteplot

ggsave("figures/Npercentsiteplot.png")

## Plot of soil C conc (%C) by site
Cpercentsiteplot <- soildata %>% 
        ggplot(aes(siteID, organicCPercent)) +
        geom_boxplot() +
        xlab("Site") +
        ylab("Soil %C")
Cpercentsiteplot

ggsave("figures/Cpercentsiteplot.png")

## Plot of ammonium by site
Ammoniumsiteplot <- soildata %>% 
        ggplot(aes(siteID, soilAmmoniumNugPerGram)) +
        geom_boxplot() +
        xlab("Site") +
        ylab("ug NH4-N g-1 soil")
Ammoniumsiteplot

ggsave("figures/Ammoniumsiteplot.png")

## Plot of NO3-/NO2- by site
Nitratesiteplot <- soildata %>% 
        ggplot(aes(siteID, soilNitrateNitriteNugPerGram)) +
        geom_boxplot() +
        xlab("Site") +
        ylab("ug NO3-N g-1 soil")
Nitratesiteplot

ggsave("figures/Nitratesiteplot.png")

## Plot of inorganic N by CN Ratio
inorgNCNplot <- soildata %>% 
        ggplot(aes(CNratio, soilInorganicNugPerGram)) +
        geom_point() +
        xlab("CN ratio") +
        ylab("ug inorganic N g-1 soil")
inorgNCNplot

## Plot of net N min by Npercent
netNminperNplot <- soildata %>% 
        ggplot(aes(nitrogenPercent, netNminugPerGramPerDay)) +
        geom_point() +
        xlab("nitrogenPercent") +
        ylab("ug net N mineralization g-1 soil day-1")
netNminperNplot

ggsave("figures/netNminperNplot.png")

## Plot of net nitrification by N percent
netNitperNplot <- soildata %>% 
        ggplot(aes(nitrogenPercent, netNitugPerGramPerDay)) +
        geom_point() +
        xlab("nitrogenPercent") +
        ylab("ug net N nitrification g-1 soil day-1")
netNitperNplot

ggsave("figures/netNitperNplot.png")

## Plot of net N min by Cpercent
netNminperCplot <- soildata %>% 
        ggplot(aes(organicCPercent, netNminugPerGramPerDay)) +
        geom_point() +
        xlab("SOC %") +
        ylab("ug net N mineralization g-1 soil day-1")
netNminperCplot

ggsave("figures/netNminperCplot.png")

## Plot of net nitrification by C percent
netNitperCplot <- soildata %>% 
        ggplot(aes(organicCPercent, netNitugPerGramPerDay)) +
        geom_point() +
        xlab("SOC %") +
        ylab("ug net N nitrification g-1 soil day-1")
netNitperCplot

ggsave("figures/netNitperCplot.png")

## Plot of soil d15N by inorganic N 
d15NinorgNplot <- soildata %>% 
        ggplot(aes(soilInorganicNugPerGram, d15N)) +
        geom_point() +
        xlab("ug inorganic N g-1 soil") +
        ylab("Soil d15N")
d15NinorgNplot

ggsave("figures/d15NinorgNplot.png")
