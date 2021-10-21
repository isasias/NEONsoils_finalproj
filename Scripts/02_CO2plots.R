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

####Plot sites separately ####

# later we can include nutrient data to this graphs so we can correlate nutrient concentration with CO2

# count the number of observations per site
Sites <- DailyCO2%>%
  count(siteID)

st <- Sites$siteID

# graphing with a for loop 

for(i in 1:length(st)) { 
  sub <- DailyCO2 %>% #subset the data
    filter(siteID == st[i])
  fig <- ggplot(data = sub,
                mapping = aes(x = JulianDay, y = dailymean)) +
    geom_path(color = "green")
  ggsave(filename = paste0("Co2plots/", st[i],"_DailyCO2_concentration.jpg"),
         fig,
         height = 4,
         width = 4,
         units = "in")
}
