library(tidyverse)
library(raster)

# Maximun temperature----
# Create a dataframe to select specific years
paths <- read.table("C:/GITHUB_REP/Palma/TMAX_paths.txt", quote="\"", comment.char="")

tabla <- data.frame("URL" = character(),
                    "Year"= numeric())

for (i in 1:nrow(paths)){
  tabla_2 <- data.frame("URL" = NA,
                      "Year"= NA)
  tabla_2[,1] <- paths[i,]
  tabla_2[,2] <- substr(paths[i,], 99, 102)
  tabla <- rbind(tabla, tabla_2)
}
# Filter and save path from 2000
tabla <- filter(tabla, Year >= 2000)
tabla <- as.vector(tabla[,1])
write(tabla, "C:/GITHUB_REP/Palma/TMAX.txt")


# Load .txt with the entire directory which download
CHELSA_dwld_paths <- readLines("C:/GITHUB_REP/Palma/TMAX.txt")
# Load and reproject iberian peninsula mask
mask <- shapefile("C:/GITHUB_REP/Palma/la_palma.shp")
mask <- spTransform(mask, "+init=epsg:4326")

# Directory to save all downloaded files
data_rep <- "B:/DATA/CHELSA/MONTHLY_1979_2019/WORLD/TMAX/" 

# Loop to download all files  

for (i in 1:length(CHELSA_dwld_paths)){
  download.file(CHELSA_dwld_paths[i],
                dest = "raster.tif",
                mode="wb")
  raster <- raster("raster.tif")
  raster <- raster %>%
    crop(mask) %>%
    mask(mask)
  raster <- raster/10
  raster <- raster - 273.15
  
  writeRaster(raster,
              paste0(data_rep,
                     str_sub(CHELSA_dwld_paths[i],
                             unlist(gregexpr("tasmax_", CHELSA_dwld_paths[i])),
                             unlist(gregexpr("_V.2", CHELSA_dwld_paths[i])) - 1), ".tif"))
}

# Minumum temperature----

# Create a dataframe to select specific years
paths <- read.table("C:/GITHUB_REP/Palma/TMIN_paths.txt", quote="\"", comment.char="")

tabla <- data.frame("URL" = character(),
                    "Year"= numeric())

for (i in 1:nrow(paths)){
  tabla_2 <- data.frame("URL" = NA,
                        "Year"= NA)
  tabla_2[,1] <- paths[i,]
  tabla_2[,2] <- substr(paths[i,], 99, 102)
  tabla <- rbind(tabla, tabla_2)
}
# Filter and save path from 2000
tabla <- filter(tabla, Year >= 2000)
tabla <- as.vector(tabla[,1])
write(tabla, "C:/GITHUB_REP/Palma/TMIN.txt")


# Load .txt with the entire directory which download
CHELSA_dwld_paths <- readLines("C:/GITHUB_REP/Palma/TMIN.txt")
# Load and reproject iberian peninsula mask
mask <- shapefile("C:/GITHUB_REP/Palma/la_palma.shp")
mask <- spTransform(mask, "+init=epsg:4326")

# Directory to save all downloaded files
data_rep <- "B:/DATA/CHELSA/MONTHLY_1979_2019/WORLD/TMIN/" 

# Loop to download all files  


for (i in 1:length(CHELSA_dwld_paths)){
  download.file(CHELSA_dwld_paths[i],
                dest = "raster.tif",
                mode="wb")
  raster <- raster("raster.tif")
  raster <- raster %>%
    crop(mask) %>%
    mask(mask)
  raster <- raster/10
  raster <- raster - 273.15
  
  writeRaster(raster,
              paste0(data_rep,
                     str_sub(CHELSA_dwld_paths[i],
                             unlist(gregexpr("tasmin_", CHELSA_dwld_paths[i])),
                             unlist(gregexpr("_V.2", CHELSA_dwld_paths[i])) - 1), ".tif"))
}
