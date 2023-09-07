#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.4.2	NDVI North America Mosaics

#This section of the process takes the MOD13Q1 and MYD13Q1 NDVI tiles in TIF format and 
#assembles a mosaic for the North America region in the native Sinusoidal projection. 
#Then reprojects and resamples the mosaics.

##Libraries
library(raster)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("D:/3_North_America_SM_predictions")

##########

#NDVI Mosaics

years <- c("2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

##MOD13Q1##

biweeks <- c("001","017","033","049","065","081","097","113",
             "129","145","161","177","193","209","225","241",
             "257","273","289","305","321","337","353")

for (i in 1:length(years)) {
  for (j in 1:length(biweeks)) {
    
    ndvi_tif_files <- list.files(path = paste0("./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MOD13Q1/0_16days_tif_tiles/",
                                               years[i],"/Tiles_",years[i], biweeks[j]), pattern = ".tif", full.names = T, recursive = T)
    
    if(length(ndvi_tif_files) <= 2){
      
      print(paste0(years[i], "  ", biweeks[j], "  Biweek with no files"))   
      
    } else {
      
      ndvi_tif_files <- lapply(ndvi_tif_files, raster)
      
      base_raster <- ndvi_tif_files[[1]]
      
      for (k in 2:length(ndvi_tif_files)) {
        
        temp_raster <- ndvi_tif_files[[k]]
        
        base_raster <- mosaic(base_raster, temp_raster, fun = mean)
        
        plot(base_raster)
        
        print(paste0(years[i], "  ", biweeks[j], "  ", k))
        
      }
      
      writeRaster(base_raster, filename = paste0("./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MOD13Q1/1_16days_Mosaics_sinusoidal/",
                                                 years[i], "/MOD13Q1_", years[i], biweeks[j], "_NorthAmerica_061_ndvi_mosaic.tif"), 
                  datatype='INT4S', overwrite = T)
      
      removeTmpFiles(h=0.01)
      
    }
  }
}


##MYD13Q1##

biweeks <- c("009","025","041","057","073","089","105","121",
             "137","153","169","185","201","217","233","249",
             "265","281","297","313","329","345","361")

for (i in 1:length(years)) {
  for (j in 1:length(biweeks)) {
    
    ndvi_tif_files <- list.files(path = paste0("./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MYD13Q1/0_16days_tif_tiles/",
                                               years[i],"/Tiles_",years[i], biweeks[j]), pattern = ".tif", full.names = T, recursive = T)
    
    if(length(ndvi_tif_files) <= 2){
      
      print(paste0(years[i], "  ", biweeks[j], "  Biweek with no files"))   
      
    } else {
      
      ndvi_tif_files <- lapply(ndvi_tif_files, raster)
      
      base_raster <- ndvi_tif_files[[1]]
      
      for (k in 2:length(ndvi_tif_files)) {
        
        temp_raster <- ndvi_tif_files[[k]]
        
        base_raster <- mosaic(base_raster, temp_raster, fun = mean)
        
        print(paste0(years[i], "  ", biweeks[j], "  ", k))
        
      }
      
      writeRaster(base_raster, filename = paste0("./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MYD13Q1/1_16days_Mosaics_sinusoidal/",
                                                 years[i], "/MYD13Q1_", years[i], biweeks[j], "_NorthAmerica_061_ndvi_mosaic.tif"), 
                  datatype='INT4S', overwrite = T)
      
      removeTmpFiles(h=0.01)
      
    }
  }
} 


##########
        
#Reprojection and resampling of North America NDVI mosaics from Sinusoidal 
#projection to LAEA projection and 250 meters cell size  
#*This process works in R but takes a long time, so I performed this in ArcPro.

reference_raster <- raster("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/NA_LandCover_2010_V2_25haMMU.tif")

#MOD13Q1

NorthAmerica_NDVI_files <- list.files(path = "./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MOD13Q1/1_16days_Mosaics_sinusoidal", 
                                      pattern = "ndvi_mosaic.tif", full.names = T, recursive = T)

for (i in 1:length(NorthAmerica_NDVI_files)) {
  
  temp_rast <- raster(NorthAmerica_NDVI_files[i])
  
  file_name <- substr(filename(temp_rast),122,158) 
  year <- substr(filename(temp_rast),130,133)
  
  temp_rast <- projectRaster(temp_rast, reference_raster)
  
  writeRaster(temp_rast, filename = paste0("./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MOD13Q1/2_16days_Mosaics_LAEA_250m/",
                                           year, "/", file_name, "_laea_mosaic.tif"), datatype='INT4S', overwrite = T)
  
  removeTmpFiles(h=0.01)
  
}


#MYD13Q1

NorthAmerica_NDVI_files <- list.files(path = "./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MYD13Q1/1_16days_Mosaics_sinusoidal", 
                                      pattern = "ndvi_mosaic.tif", full.names = T, recursive = T)

for (i in 1:length(NorthAmerica_NDVI_files)) {
  
  temp_rast <- raster(NorthAmerica_NDVI_files[i])
  
  file_name <- substr(filename(temp_rast),122,158) 
  year <- substr(filename(temp_rast),130,133)
  
  temp_rast <- projectRaster(temp_rast, reference_raster)
  
  writeRaster(temp_rast, filename = paste0("./1_Preprocessed_data/4_NorthAmerica_MODIS_NDVI/MYD13Q1/2_16days_Mosaics_LAEA_250m/",
                                           year, "/", file_name, "_laea_mosaic.tif"), datatype='INT4S', overwrite = T)
  
  removeTmpFiles(h=0.01)
  
} 

