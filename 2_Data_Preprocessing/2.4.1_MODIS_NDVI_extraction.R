#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.4.1 Extraction of NDVI layers from MODIS HDF files and export to TIF format

#This section of the process reads the 16-days MOD13Q1 and MYD13Q1 composites in their native HDF format, 
#extracts the layer with the NDVI information and exports it to TIF format.

##Libraries
library(raster)
library(gdalUtils)
library(ncdf4)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("E:/3_North_America_SM_predictions")

##########

#Extraction of NDVI layers from HDF files and export to TIF format
#This process does not work on Windows 11 due to GDAL compatibility. 

##MOD13Q1##

hdf_files <- list.files(path = "./0_Input_data/4_MODIS_NDVI/MOD13Q1_hdf_files", 
                        pattern = ".hdf", full.names = T, recursive = T)  

for (i in 1:length(hdf_files)) {
  
  composite_name <- substr(hdf_files[i], 59, 85)
  year <- substr(composite_name, 10, 13)
  biweek <- substr(composite_name, 10, 16)
  
  sds <- get_subdatasets(hdf_files[i])
  
  gdal_translate(sds[1], dst_dataset = paste0("./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MOD13Q1/0_16days_tif_tiles/",
                                              year, "/", "Tiles_", biweek, "/", composite_name, "_ndvi.tif"))
  
  print(i)
  print(composite_name)
  
}

##MYD13Q1##

hdf_files <- list.files(path = "./0_Input_data/4_MODIS_NDVI/MYD13Q1_hdf_files", 
                        pattern = ".hdf", full.names = T, recursive = T)    

for (i in 1:length(hdf_files)) {
  
  composite_name <- substr(hdf_files[i], 59, 85)
  year <- substr(composite_name, 10, 13)
  biweek <- substr(composite_name, 10, 16)
  
  sds <- get_subdatasets(hdf_files[i])
  
  gdal_translate(sds[1], dst_dataset = paste0("./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MYD13Q1/0_16days_tif_tiles/"
                                              , year, "/", "Tiles_", biweek, "/", composite_name, "_ndvi.tif"))
  
  print(i)
  print(composite_name)
  
}

