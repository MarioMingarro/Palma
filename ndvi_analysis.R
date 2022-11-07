library(raster)

ndvi <- raster("C:/GITHUB_REP/Palma/NDVI/La_Palma_ndvi_20.tif")

mask <- shapefile("C:/GITHUB_REP/Palma/la_palma.shp")
mask <- spTransform(mask, "+init=epsg:4326")

ndvi <- mask(crop(ndvi, mask), mask)
plot(ndvi)
