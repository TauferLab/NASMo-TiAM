#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.6.1 Extraction of Snow Cover layers from MODIS HDF files and export to TIF format

#This section of the process reads the 8-days MOD10A2 and MYD10A2 composites in their native HDF format, 
#extracts the layer with the Snow Cover information and exports it to TIF format.

##Libraries
library(raster)
library(gdalUtils)
library(ncdf4)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("D:/3_North_America_SM_predictions")

##########

#Extraction of Snow Cover layer from HDF files and export to TIF format
#This process does not work in Windows 11 due to GDAL compatibility. 

##MOD10A2##

hdf_files <- list.files(path = "./0_Input_data/6_SNOW_cover_masks/MOD10A2_hdf_files"
                        , pattern = ".hdf", full.names = T, recursive = T)  

for (i in 1:length(hdf_files)) {
  
  composite_name <- substr(hdf_files[i], 65, 91)
  year <- substr(composite_name, 10, 13)
  biweek <- substr(composite_name, 10, 16)
  
  sds <- get_subdatasets(hdf_files[i])
  
  gdal_translate(sds[1], dst_dataset = paste0("./1_Preprocessed_data/6_SNOW_cover_masks/MOD10A2/0_8days_tif_tiles/", 
                                              year, "/", "Tiles_", biweek, "/", composite_name, "_lst.tif"))
  
  print(i)
  print(composite_name)
  
}

##MYD10A2##

hdf_files <- list.files(path = "./0_Input_data/6_SNOW_cover_masks/MYD10A2_hdf_files"
                        , pattern = ".hdf", full.names = T, recursive = T)  

for (i in 1:length(hdf_files)) {
  
  composite_name <- substr(hdf_files[i], 65, 91)
  year <- substr(composite_name, 10, 13)
  biweek <- substr(composite_name, 10, 16)
  
  sds <- get_subdatasets(hdf_files[i])
  
  gdal_translate(sds[1], dst_dataset = paste0("./1_Preprocessed_data/6_SNOW_cover_masks/MYD10A2/0_8days_tif_tiles/", 
                                              year, "/", "Tiles_", biweek, "/", composite_name, "_lst.tif"))
  
  print(i)
  print(composite_name)
  
}

