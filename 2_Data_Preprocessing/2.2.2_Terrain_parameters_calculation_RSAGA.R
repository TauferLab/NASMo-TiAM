#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.2.2 Calculation of Terrain Parameters

#This part of the process calculates 15 terrain parameters at 250m using the “Basic Terrain Analysis” 
#tool in the “TA compound analysis” of RSAGA. The DEM must be in a projection based on metric 
#units (e.g., LAEA). Once the parameters are calculated, each raster output must be reprojected 
#to WGS84 to be comparable with the ESA-CCI biweekly means created in script 2.1

##Libraries
library(raster)
library(RSAGA)
library(doParallel)
library(foreach)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("E:/3_North_America_SM_predictions")

##########

myenv <- rsaga.env(workspace =".", path="E:/saga-7.9.0_x64/", parallel=TRUE)

rsaga.import.gdal("./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/2_GMTED2010_NorthAmerica_mosaic_final/NorthAmerica_GMTED2010_mosaic_LAEA_250m.tif", 
                  "./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/3_RSAGA_NorthAmerica_terrain_parameters/1_LAEA/NorthAmerica_LAEA_250m_elevation.sgrd", env = myenv)

rsaga.geoprocessor("ta_compound", module = "Basic Terrain Analysis",
                   param = list(ELEVATION = "NorthAmerica_LAEA_250m_elevation.sgrd",
                                SHADE = "NorthAmerica_LAEA_250m_analytical_hillshading.sgrd",
                                SLOPE = "NorthAmerica_LAEA_250m_slope.sgrd",
                                ASPECT = "NorthAmerica_LAEA_250m_aspect.sgrd",
                                HCURV = "NorthAmerica_LAEA_250m_plan_curvature.sgrd",
                                VCURV = "NorthAmerica_LAEA_250m_profile_curvature.sgrd",
                                CONVERGENCE = "NorthAmerica_LAEA_250m_convergence_index.sgrd",
                                SINKS = "NorthAmerica_LAEA_250m_clossed_depressions.sgrd",
                                FLOW = "NorthAmerica_LAEA_250m_total_catchment_area.sgrd",
                                WETNESS = "NorthAmerica_LAEA_250m_topographic_wetness_index.sgrd",
                                LSFACTOR = "NorthAmerica_LAEA_250m_ls_factor.sgrd",
                                CHANNELS = "NorthAmerica_LAEA_250m_channels.sgrd",
                                BASINS = "NorthAmerica_LAEA_250m_basins.sgrd",
                                CHNL_BASE = "NorthAmerica_LAEA_250m_channel_network_base_level.sgrd",
                                CHNL_DIST = "NorthAmerica_LAEA_250m_channel_network_distance.sgrd",
                                VALL_DEPTH = "NorthAmerica_LAEA_250m_valley_depth.sgrd",
                                RSP = "NorthAmerica_LAEA_250m_relative_slope_position.sgrd"),
                   show.output.on.console = TRUE, env = myenv)


##########

#Reprojection from LAEA CRS to WGS84 and transformation to TIF format. This process can be performed 
#in parallel. This process works in R, but it was performed in ArcPro as it preservers better the 
#cell size when it goes from LAEA to WGS84.

sdat_files <- list.files(path = "./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/3_RSAGA_NorthAmerica_terrain_parameters/1_LAEA", 
                         pattern = ".sdat", full.names = T, recursive = T)

WGS84_projection <- "+proj=longlat +datum=WGS84 +no_defs"

UseCores <- detectCores() -2
cl <- makeCluster(UseCores)
registerDoParallel(cl)

foreach (i = 1:length(sdat_files)) %dopar% {
  
  library(raster)
  
  rast_file <- raster(sdat_files[[i]])
  rast_file <- projectRaster(rast_file, crs = WGS84_projection)
  
  file_name <- names(rast_file)
  
  writeRaster(rast_file, paste0("./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/3_RSAGA_NorthAmerica_terrain_parameters/2_WGS84/", 
                                file_name, "_wgs84.tif"), overwrite = TRUE)
  
  print(i)
  print(file_name)
  
  gc() 
  removeTmpFiles(h=0.01)
  
}

stopCluster(cl)


