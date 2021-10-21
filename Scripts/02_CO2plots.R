#### Libraries ####

library(dplyr)
library(tidyr)
library(ggplot2)
install.packages("lubridate") # change to julian day
library(lubridate)

#### Import filtered data ####

SoilCO2 <- read.csv(file = "Data/SoilCO2_filtered.csv")
View(SoilCO2)

#### Average by day ####


SoilCO2 <- SoilCO2 %>%
  filter(!is.na(soilCO2concentrationMean))

# add julian day 
SoilCO2$JulianDay <- yday(SoilCO2$endDateTime)

DailyCO2 <- SoilCO2 %>%
  group_by(siteID,JulianDay)%>%
  summarise(dailymean = mean(soilCO2concentrationMean))

unique(DailyCO2$siteID)


#### Plot data by site ####

ggplot(data = DailyCO2)+
  geom_path(aes(JulianDay, dailymean, color = siteID))
