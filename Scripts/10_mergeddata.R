
library(dplyr)
library(tidyr)
library(ggplot2)

## Import filtered data 

# Soil CO2
SoilCO2 <- read.csv(file = "Data/DailySoilCO2_filtered.csv")

#Soil nutrients 
Soilnut <- read.csv(file = "Data/totalsoildata.csv")

### Summarize soil nutrients by mean

Dailynug <- Soilnut %>%
  group_by(siteID,JulianDay)%>%
  summarise(Nugmean = mean(soilInorganicNugPerGram, na.rm = TRUE), Nmean = mean(nitrogenPercent, na.rm = TRUE))

### Merge both sets of data 

MergedSoil <- left_join(SoilCO2,Dailynug)

### Mean soil CO2 yearly
YearCO2 <- MergedSoil %>%
  group_by(siteID) %>%
  summarise(CO2year = mean(dailymean))

Sitenitrogen <- Soilnut %>%
  group_by(siteID) %>%
  summarise(InorganicN = mean(soilInorganicNugPerGram, na.rm = TRUE))

#### ggplot
CO2N <- full_join(YearCO2,Sitenitrogen)

ggplot(data = CO2N) +
  geom_point(aes(x= CO2year, y= InorganicN, color = siteID))

###
ggplot(data = MergedSoil) +
  geom_line(aes(x= JulianDay, y= dailymean, color = siteID))

### Vectors for for loop
Sites <- SoilCO2%>%
  count(siteID)

#new vector created for the for loop
st <- Sites$siteID

### create a data frame coefficient for the scaling

nugmax <- tapply(MergedSoil$Nugmean, MergedSoil$siteID, max, na.rm = TRUE)
CO2max <- tapply(MergedSoil$dailymean, MergedSoil$siteID, max)

coeff <- data.frame(Sites = st, coefficient = CO2max/nugmax)
coeff2 <- 4500

for(i in 1:length(st)) { 
  sub <- MergedSoil %>% 
    filter(siteID == st[i])
  fig <- ggplot(data = sub, aes(x = JulianDay)) +
    geom_col(fill = "brown", mapping = aes(y= Nugmean*coeff2 ), width = 2, stat = "identity") +
    geom_path(mapping = aes(y= dailymean), size = 1,  color = "forestgreen") +
    scale_y_continuous(name = "Daily CO2 soil concentration (ppm)", sec.axis = sec_axis(~./coeff2, name = "Soil Inorganic Nug per Gram")) +
    ggtitle(st[i])
  ggsave(filename = paste0("Co2nut_graphs/", st[i],"_DailyCO2_concentration.jpg"),
         fig,
         height = 4,
         width = 4,
         units = "in")
}

# ggplot(data = MergedSoil, aes(x = JulianDay)) +
#   geom_bar(fill = "orange", mapping = aes(y= Nmean*coeff == st[i]), stat = "identity") +
#   geom_path(mapping = aes(y= dailymean), size = 1,  color = "forestgreen") +
#   scale_y_continuous(name = "Daily CO2 soil concentration (ppm)", sec.axis = sec_axis(~./["coeff"], name = "Nitrogen percent in soil")) 
