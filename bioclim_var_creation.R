library(tidyverse)
library(raster)

# BIO1 = Annual Mean Temperature
# 
# BIO2 = Mean Diurnal Range (Mean of monthly * (max temp - min temp))
# 
# BIO3 = Isothermality (BIO2/BIO7) (×100)
# 
# BIO4 = Temperature Seasonality (standard deviation ×100)
# 
# BIO5 = Max Temperature of Warmest Month
# 
# BIO6 = Min Temperature of Coldest Month
# 
# BIO7 = Temperature Annual Range (BIO5-BIO6)
# 
# BIO8 = Mean Temperature of Wettest Quarter
# 
# BIO9 = Mean Temperature of Driest Quarter
# 
# BIO10 = Mean Temperature of Warmest Quarter
# 
# BIO11 = Mean Temperature of Coldest Quarter
# 
# BIO12 = Annual Precipitation
# 
# BIO13 = Precipitation of Wettest Month
# 
# BIO14 = Precipitation of Driest Month
# 
# BIO15 = Precipitation Seasonality (Coefficient of Variation)
# 
# BIO16 = Precipitation of Wettest Quarter
# 
# BIO17 = Precipitation of Driest Quarter
# 
# BIO18 = Precipitation of Warmest Quarter
# 
# BIO19 = Precipitation of Coldest Quarter





### Monthly data to annual average ----
TMAX <- raster::stack()

for (i in 2000:2019){
  raster <- calc(raster::stack(list.files("B:/DATA/CHELSA/MONTHLY_1979_2019/PALMA/TMAX", pattern = paste0(i), full.names = TRUE)), mean) # MEAN
  TMAX <- raster::stack(TMAX, raster)
}
names(TMAX) <- paste0("Y_", seq(2000, 2019, by = 1))


TMIN <- raster::stack()

for (i in 2000:2019){
  raster <- calc(raster::stack(list.files("B:/DATA/CHELSA/MONTHLY_1979_2019/PALMA/TMIN", pattern = paste0(i), full.names = TRUE)), mean) # MEAN
  TMIN <- raster::stack(TMIN, raster)
}
names(TMIN) <- paste0("Y_", seq(2000, 2019, by = 1))

### Monthly precipitation data to annual ----
PCP_annual <- raster::stack()
for (i in 2000:2018){
  raster <- calc(raster::stack(list.files("B:/DATA/CHELSA/MONTHLY_1979_2019/PALMA/PCP", pattern = paste0(i), full.names = TRUE)), sum) #SUM
  PCP_annual <- raster::stack(PCP_annual, raster)
}
names(PCP_annual) <- paste0("Y_", seq(2000, 2018, by = 1))
plot(PCP_annual)

# Bioclim variables ----
### Annual Mean Temperature ----
BIO1 <- calc(raster::stack(TMAX, TMIN), mean)
plot(BIO1)

### Annual Precipitation ----

BIO12 <- calc(PCP_annual, mean)
plot(BIO12)

#(Mean of monthly * (max temp - min temp))
BIO2 <- raster::stack()

for (i in 2000:2003){
  max_t <- calc(raster::stack(list.files("B:/DATA/CHELSA/MONTHLY_1979_2019/PALMA/TMAX", pattern = paste0(i), full.names = TRUE)), max) 
  min_t <- calc(raster::stack(list.files("B:/DATA/CHELSA/MONTHLY_1979_2019/PALMA/TMIN", pattern = paste0(i), full.names = TRUE)), min)
  mean_max_t <- calc(raster::stack(list.files("B:/DATA/CHELSA/MONTHLY_1979_2019/PALMA/TMAX", pattern = paste0(i), full.names = TRUE)), mean)
  mean_min_t <- calc(raster::stack(list.files("B:/DATA/CHELSA/MONTHLY_1979_2019/PALMA/TMIN", pattern = paste0(i), full.names = TRUE)), mean)
  mean_t <- stack(mean_max_t, mean_min_t)
  mean_t <- calc(mean_t, mean)
  raster <- mean_t*(max_t - min_t)
  BIO2 <- raster::stack(BIO2, raster)
}
BIO2 <- calc(BIO2, mean)

### Max Temperature of Warmest Month
BIO5 <- raster::stack()
i=2019
for (i in 2000:2003){
  raster <- calc(raster::stack(list.files("B:/DATA/CHELSA/MONTHLY_1979_2019/PALMA/TMAX", pattern = paste0(i), full.names = TRUE)), max) 
  BIO5 <- raster::stack(BIO5, raster)
}


BIO5 <- calc(BIO5, mean)

### Min Temperature of Coldest Month
BIO6 <- raster::stack()

for (i in 2000:2019){
  raster <- calc(raster::stack(list.files("B:/DATA/CHELSA/MONTHLY_1979_2019/PALMA/TMIN", pattern = paste0(i), full.names = TRUE)), min) 
  BIO6 <- raster::stack(BIO6, raster)
}


BIO6 <- calc(BIO6, mean)

###  BIO7 = Temperature Annual Range (BIO5-BIO6)--- 
BIO7 <- BIO5-BIO6