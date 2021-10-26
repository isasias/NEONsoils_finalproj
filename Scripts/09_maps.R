# Map of our selected sites on maps for visualization


## Loading libraries
install.packages("Rtools")
devtools::install_github("wmurphyrd/fiftystater")
devtools::install_github("valentinitnelav/plotbiomes")
library(ggplot2)
library(tidyverse)
library(fiftystater)
library(plotbiomes)

## Reading in the locations and names of our sites
mapdata <- read.csv("data_raw/site_locations.csv", stringsAsFactors = FALSE)
mapdata %>% glimpse()

## Base USA Map
data("fifty_states")
ggplot() + geom_polygon(data = fifty_states, aes(x=long, y=lat, group=group), color="white", fill="grey10")

## USA map with our site locations
ggplot() + geom_polygon(data=fifty_states, aes(x=long, y=lat, group = group),color="white", fill="grey92" ) + 
  geom_point(data=mapdata, aes(x=field_longitude, y=field_latitude), color="black") + 
  geom_text(data=mapdata, aes(x=field_longitude, y=field_latitude, label=field_site_name, hjust=-0.05), 
            size = 3) +
  scale_size(name="", range = c(2, 20)) + 
  theme_void()

ggsave("site_locations.png", width = 14.4, height = 7.43, units = "in")


## Make plot with site location on Whittaker_biomes using plotbiomes package
plot_1 <- ggplot() +
  geom_polygon(data = Whittaker_biomes,
               aes(x    = temp_c,
                   y    = precp_cm,
                   fill = biome),
               # adjust polygon borders
               colour = "gray98",
               size   = 1) +
  labs(y = "Precipitation (cm)", x = "Temperature (°C)")+
  theme_bw() +
  scale_fill_manual(name   = "Whittaker biomes",
                    breaks = names(Ricklefs_colors),
                    labels = names(Ricklefs_colors),
                    values = Ricklefs_colors) 

plot_1


## Function to add points from sites 
mapdata <- mapdata %>%
  mutate(field_mean_annual_precipitation_cm = field_mean_annual_precipitation_mm/10)

Whittacker_plot_fun<-function(df1){
  plot_1 +
    geom_point(data = mapdata, 
               aes(x = field_mean_annual_temperature_C, 
                   y = field_mean_annual_precipitation_cm), 
               size   = 2.5,
               shape  = 21,
               colour = "gray90", 
               fill   = "gray10") +
    theme_bw()+ 
    theme(axis.text = element_text(size = 12),
          axis.title = element_text(size = 12),
          legend.text = element_text(size = 10),
          plot.title = element_text(hjust = 0.5, size =14)) +
    geom_text(data=mapdata, aes(x=field_mean_annual_temperature_C, y=field_mean_annual_precipitation_cm, 
                                label=domainName, hjust=-0.05), 
              size = 3)
}
ggsave("whittaker_locations.png")
