#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.5.1 Extraction of Land Surface Temperature layers from MODIS HDF files and export to TIF format

#This section of the process reads the 8-days MOD11A2 and MYD11A2 composites in their native HDF format, 
#extracts the layer with the LST information and exports it to TIF format.

##Libraries
library(raster)
library(gdalUtils)
library(ncdf4)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("E:/3_North_America_SM_predictions")

##########

#Extraction of LST layer from HDF files and export to TIF format
#This process does not work on Windows 11 due to GDAL compatibility. 

##MOD11A2##

hdf_files <- list.files(path = "./0_Input_data/5_MODIS_TEMPERATURE/MOD11A2_hdf_files"
                        , pattern = ".hdf", full.names = T, recursive = T)  

for (i in 1:length(hdf_files)) {
  
  composite_name <- substr(hdf_files[i], 66, 92)
  year <- substr(composite_name, 10, 13)
  biweek <- substr(composite_name, 10, 16)
  
  sds <- get_subdatasets(hdf_files[i])
  
  gdal_translate(sds[1], dst_dataset = paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MOD11A2/0_8days_tif_tiles/", 
                                              year, "/", "Tiles_", biweek, "/", composite_name, "_lst.tif"))
  
  print(i)
  print(composite_name)
  
}

##MYD11A2##

hdf_files <- list.files(path = "./0_Input_data/5_MODIS_TEMPERATURE/MYD11A2_hdf_files"
                        , pattern = ".hdf", full.names = T, recursive = T)  

for (i in 1:length(hdf_files)) {
  
  composite_name <- substr(hdf_files[i], 66, 92)
  year <- substr(composite_name, 10, 13)
  biweek <- substr(composite_name, 10, 16)
  
  sds <- get_subdatasets(hdf_files[i])
  
  gdal_translate(sds[1], dst_dataset = paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MYD11A2/0_8days_tif_tiles/", 
                                              year, "/", "Tiles_", biweek, "/", composite_name, "_lst.tif"))
  
  print(i)
  print(composite_name)
  
}

