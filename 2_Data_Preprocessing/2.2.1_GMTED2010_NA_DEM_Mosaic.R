#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.2.1 Assembly of Digital Elevation Model (DEM) for North America

#This part of the process imports the mean elevation layers from the GMTED2010 DEM tiles 
#at 7.5 arc-second (WGS84), reprojects the tiles to Lambert Azimuthal Equal Area (LAEA) 
#projection at 250 meters, and creates a mosaic cropped and masked to the North American region.

##Libraries
library(raster)
library(doParallel)
library(foreach)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("D:/3_North_America_SM_predictions")

##########

#Reprojection from WGS84 (geographic coordinates) to LAEA (metric coordinates).
#This step is necessary to calculate terrain parameters in RSAGA

#The reference raster file in LAEA and 250 meters is the Land Cover map of North America 2010, published by the Commission by Environmental Cooperation
reference_raster <- raster("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/NA_LandCover_2010_V2_25haMMU.tif")

DEM_files <- list.files(path = "./0_Input_data/2_GMTED2010_075sec/", pattern = "gmted_mea075.tif", full.names = T, recursive = T)

#This code runs in parallel 
UseCores <- detectCores() -4
cl <- makeCluster(UseCores)
registerDoParallel(cl)

foreach (i = 1:length(DEM_files)) %dopar% {
  
  library(raster)
  
  DEM_name <- substr(DEM_files[i], 57,63)
  
  DEM_base <- raster(DEM_files[i])
  DEM_base <- projectRaster(DEM_base, reference_raster)
  plot(DEM_base)
  
  writeRaster(DEM_base, paste0("./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/0_GMTED2010_reprojected_tiles/NorthAmerica_GMTED2010_", 
                               DEM_name, "_LAEA_250m__.tif"), overwrite = TRUE)
  
  print(paste0(i, " out of ", length(DEM_files)))
  
  gc() 
  removeTmpFiles(h=0.01)
  
}

stopCluster(cl)


##########

#Mosaic reprojected tiles

DEM_files_reprojected <- list.files(path = "./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/0_GMTED2010_reprojected_tiles/",
                                    pattern = "NorthAmerica_GMTED2010", full.names = T, recursive = T)

rasters_list <- stack(DEM_files_reprojected[1])

for (i in 2:length(DEM_files_reprojected)) {
  
  raster_temp <- stack(DEM_files_reprojected[i])
  rasters_list <- stack(rasters_list, raster_temp)
  print(i)  
  
}

rasters_list <- as.list(rasters_list)

rasters_list$fun <- mean
rasters_list$na.rm <- TRUE

northamerica_mosaic <- do.call(mosaic, rasters_list)

writeRaster(northamerica_mosaic, paste0("./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/1_GMTED2010_NorthAmerica_mosaic/NorthAmerica_GMTED2010_mosaic_LAEA_250m_temp.tif"))

gc() 
removeTmpFiles(h=0.01)


##########

#Masking of North American DEM mosaic. The output keeps data only within the North America boundary
#*This process works in R but takes a long time, so I performed this in ArcPro.

reference_boundary <- shapefile("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/NA_LandCover_Boundary_2010_250m.shp")

base_raster <- raster("./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/1_GMTED2010_NorthAmerica_mosaic/NorthAmerica_GMTED2010_mosaic_LAEA_250m_temp.tif")

NA_DEM_final <- mask(base_raster, reference_boundary)

writeRaster(NA_DEM_final, paste0("E:/3_North_America_SM_predictions/1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/2_GMTED2010_NorthAmerica_mosaic_final/NorthAmerica_GMTED2010_mosaic_LAEA_250m.tif"))

gc() 
removeTmpFiles(h=0.01)
