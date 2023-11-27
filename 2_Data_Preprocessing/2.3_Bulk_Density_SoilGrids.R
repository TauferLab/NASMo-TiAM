#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.3 Bulk Density data preparation for North America

#This section takes all 0-5cm depth Bulk Density global tiles available in the Soil Grids system, 
#creates a global mosaic, crops the data to the North America region, runs a reprojection and resample 
#the data to the same coordinate reference system and cell size as the ESA-CCI preprocessed biweekly 
#means and the preprocessed terrain parameters.

##Libraries
library(raster)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("E:/3_North_America_SM_predictions")

##########

#SoilGrids generation of a global Bulk Density Layer (250 meters)

BulkDensity_files <- list.files(path = "./0_Input_data/3_SoilGrids_BulkDensity/bdod_0-5cm_mean",
                                pattern = ".tif", full.names = T, recursive = T)

base_raster <- raster(BulkDensity_files[1])

for (i in 2:length(BulkDensity_files)) {
  
  raster_temp <- raster(BulkDensity_files[i])
  tile_name <- names(raster_temp)
  base_raster <- mosaic(base_raster, raster_temp, fun = max)
  
  plot(base_raster)
  
  print(paste0(i, " out of ", length(BulkDensity_files)))
  print(tile_name)
  
  writeRaster(base_raster, 
              filename = "./1_Preprocessed_data/3_NorthAmerica_BulkDensity/0_Global_BulkDensity_Mosaic/soilgrids_global_bulkdensity_homolosine.tif",   
              overwrite = TRUE)
  
  gc() 
  removeTmpFiles(h=0.01)
  
}


##########
        
#Global Bulk density reprojection, crop and mask to the North America region.
#*This process works in R but takes a long time, so it was performed in ArcPro.

NorthAmerica_boundary <- shapefile("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/00_northamerica_region_interest_wgs84.shp")

rast_file <- raster("./1_Preprocessed_data/3_NorthAmerica_BulkDensity/0_Global_BulkDensity_Mosaic/soilgrids_global_bulkdensity_homolosine.tif")

WGS84_projection <- "+proj=longlat +datum=WGS84 +no_defs"

temp_rast <- projectRaster(rast_file, crs = WGS84_projection)

temp_rast <- crop(temp_rast, NorthAmerica_boundary)

temp_rast <- mask(temp_rast, NorthAmerica_boundary)

plot(temp_rast)

writeRaster(temp_rast, filename = "./1_Preprocessed_data/3_NorthAmerica_BulkDensity/4_NorthAmerica_BulkDensity_WGS84/soilgrids_northamerica_bulkdensity_wgs84.tif", 
            overwrite = TRUE)

