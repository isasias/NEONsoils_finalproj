#### libraries ####

library(neonUtilities)
library(dplyr)
library(tidyr)


#### Download CO2 data ####

#NEON token

NEON_token <- "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJhdWQiOiJodHRwczovL2RhdGEubmVvbnNjaWVuY2Uub3JnL2FwaS92MC8iLCJzdWIiOiJpc2Euc2lhczE1MUBnbWFpbC5jb20iLCJzY29wZSI6InJhdGU6cHVibGljIiwiaXNzIjoiaHR0cHM6Ly9kYXRhLm5lb25zY2llbmNlLm9yZy8iLCJleHAiOjE3OTIzNjI3ODAsImlhdCI6MTYzNDY4Mjc4MCwiZW1haWwiOiJpc2Euc2lhczE1MUBnbWFpbC5jb20ifQ.dsusk6Xh61IjlR2TRBAENp87Wz31odd47epMtZBlL8RKwspRRb_Y9tU9BlPpWTRBU4kwrwPmN4ihVNSRtg_9NA"

# Soil CO2 concentration 

SoilCO2conc <- loadByProduct(dpID = "DP1.00095.001", 
                             site = c("JERC", "UNDE", "KONA", "DELA", "DCFS", "NIWO", "WREF", "BONA"),
                             startdate = "2019-06", enddate = "2019-10",
                             timeIndex = "30",
                             token = NEON_token)

#USE THIS CODE IN CASE IT IS NECESSARY TO REDUCE THE STORAGE SPACE
# SCC1 <- loadByProduct(dpID = "DP1.00095.001", 
#                       site = c("UNDE", "NIWO"),
#                       startdate = "2019-06", enddate = "2019-10",
#                       timeIndex = "30")
# SCC2 <- loadByProduct(dpID = "DP1.00095.001", 
#                       site = c("JERC", "DELA","DCFS"),
#                       startdate = "2019-07", enddate = "2019-08",
#                       timeIndex = "30")
# SCC3 <- loadByProduct(dpID = "DP1.00095.001", 
#                       site = c("KONA", "WREF"),
#                       startdate = "2019-06", enddate = "2019-07",
#                       timeIndex = "30")
# SCC4 <- loadByProduct(dpID = "DP1.00095.001", 
#                       site = c("KONA", "WREF","DCFS"),
#                       startdate = "2019-10", enddate = "2019-10",
#                       timeIndex = "30")
# SCC5 <- loadByProduct(dpID = "DP1.00095.001", 
#                       site = "BONA",
#                       startdate = "2019-08", enddate = "2019-09",
#                       timeIndex = "30")

list2env(SoilCO2conc, .GlobalEnv)
View(SCO2C_30_minute)

### Data Filtering ####

unique(SCO2C_30_minute$siteID)


# UNDE and NIWO does not need date filtering 

SCO2_UN <- SCO2C_30_minute %>%
  filter(siteID == c("UNDE", "NIWO")) %>%
  separate(startDateTime, c(NA, "Month", "Date", "Hour")) ## This allows to filter by months since nutrient data does not have all the months
unique(SCO2_UN$siteID)

# JERC DELA and DCFS July and August 

SCO2_JDD <- SCO2C_30_minute %>% 
  filter(siteID == c("JERC", "DELA", "DCFS")) %>%
  separate(startDateTime, c(NA, "Month", "Date", "Hour")) %>%
  filter(Month == c("07","08"))

# DCFS October
SCO2_DC <- SCO2C_30_minute %>% 
  filter(siteID == "DCFS") %>%
  separate(startDateTime, c(NA, "Month", "Date", "Hour")) %>%
  filter(Month == "10")

unique(SCO2_DC$Month)

# KONA and WREF June July October

SCO2_KW <- SCO2C_30_minute %>% 
  filter(siteID == c("KONA", "WREF")) %>%
  separate(startDateTime, c(NA, "Month", "Date", "Hour")) %>%
  filter(Month == c("06","07", "10"))

# BONA August September

SCO2_BO <- SCO2C_30_minute %>% 
  filter(siteID == "BONA") %>%
  separate(startDateTime, c(NA, "Month", "Date", "Hour")) %>%
  filter(Month == c("08", "09"))

# Join all filtered data to one table 

SCO2filtered <- rbind(SCO2_UN, SCO2_KW, SCO2_JDD, SCO2_DC, SCO2_BO)

# Save data frame into csv to use in later transcripts as well as other elements from the list

write.csv(SCO2filtered, file = "SoilCO2_filtered.csv")
write.csv(variables_00095, file = "variables_00095.csv")
write.csv(sensor_positions_00095, file = "sensor_positions_00095.csv")
write.csv(readme_00095, file = "readme_00095.csv")
