#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.6.2	Snow Cover North America Mosaics

#This section of the process takes the MOD10A2 and MYD10A2 LST tiles in TIF format and 
#assembles a mosaic for the North America region in the native Sinusoidal projection. 
#Then reprojects and resamples the mosaics.

##Libraries
library(raster)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("D:/3_North_America_SM_predictions")

##########

#SNOW Mosaics

years <- c("2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

weeks <- c("001","009","017","025","033","041","049","057","065",
           "073","081","089","097","105","113","121","129","137",
           "145","153","161","169","177","185","193","201","209",
           "217","225","233","241","249","257","265","273","281",
           "289","297","305","313","321","329","337","345","353","361")

##MOD10A2##

for (i in 1:length(years)) {
  for (j in 1:length(weeks)) {
    
    snow_tif_files <- list.files(path = paste0("./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MOD10A2/0_8days_tif_tiles/",
                                              years[i],"/Tiles_",years[i], weeks[j]), pattern = ".tif", full.names = T, recursive = T)
    
    if(length(snow_tif_files) <= 2){
      
      print(paste0(years[i], "  ", weeks[j], "  Week with no files"))   
      
    } else {
      
      snow_tif_files <- lapply(snow_tif_files, raster)
      
      base_raster <- snow_tif_files[[1]]
      
      for (k in 2:length(snow_tif_files)) {
        
        temp_raster <- snow_tif_files[[k]]
        
        base_raster <- mosaic(base_raster, temp_raster, fun = mean)
        
        plot(base_raster)
        
        print(paste0(years[i], "  ", weeks[j], "  ", k))
        
      }
      
      writeRaster(base_raster, filename = paste0("./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MOD10A2/1_8days_Mosaics_sinusoidal/",
                                                 years[i], "/MOD10A2_", years[i], weeks[j], "_NorthAmerica_061_snow_mosaic.tif"), 
                  datatype='INT4S', overwrite = T)
      
      removeTmpFiles(h=0.01)
      
    }
  }
}


##MYD10A2##

for (i in 1:length(years)) {
  for (j in 1:length(weeks)) {
    
    lst_tif_files <- list.files(path = paste0("./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MYD10A2/0_8days_tif_tiles/",
                                              years[i],"/Tiles_",years[i], weeks[j]), pattern = ".tif", full.names = T, recursive = T)
    
    if(length(lst_tif_files) <= 2){
      
      print(paste0(years[i], "  ", weeks[j], "  Week with no files"))   
      
    } else {
      
      lst_tif_files <- lapply(lst_tif_files, raster)
      
      base_raster <- lst_tif_files[[1]]
      
      for (k in 2:length(lst_tif_files)) {
        
        temp_raster <- lst_tif_files[[k]]
        
        base_raster <- mosaic(base_raster, temp_raster, fun = mean)
        
        plot(base_raster)
        
        print(paste0(years[i], "  ", weeks[j], "  ", k))
        
      }
      
      writeRaster(base_raster, filename = paste0("./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MYD10A2/1_8days_Mosaics_sinusoidal/",
                                                 years[i], "/MYD10A2_", years[i], weeks[j], "_NorthAmerica_061_snow_mosaic__.tif"), 
                  datatype='INT4S', overwrite = T)
      
      removeTmpFiles(h=0.01)
      
    }
  }
}


##########

#Reprojection and resampling of North America Snow Cover mosaics from Sinusoidal 
#projection to LAEA projection and 250 meters cell size  
#*This process works in R but takes a long time, so I performed this in Arc Pro.

reference_raster <- raster("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/NA_LandCover_2010_V2_25haMMU.tif")

#MOD10A2

NorthAmerica_SNOW_files <- list.files(path = "./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MOD10A2/1_8days_Mosaics_sinusoidal", 
                                     pattern = "snow_mosaic.tif", full.names = T, recursive = T)

for (i in 1:length(NorthAmerica_SNOW_files)) {
  
  temp_rast <- raster(NorthAmerica_SNOW_files[i])
  
  file_name <- substr(filename(temp_rast),121,157) 
  year <- substr(filename(temp_rast),129,132)
  
  temp_rast <- projectRaster(temp_rast, reference_raster)
  
  writeRaster(temp_rast, filename = paste0("./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MOD10A2/2_8days_Mosaics_LAEA_250m/",
                                           year, "/", file_name, "_laea_mosaic.tif"), datatype='INT4S', overwrite = T)
  
  removeTmpFiles(h=0.01)
  
}


#MYD10A2

NorthAmerica_SNOW_files <- list.files(path = "./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MYD10A2/1_8days_Mosaics_sinusoidal", 
                                     pattern = "snow_mosaic.tif", full.names = T, recursive = T)

for (i in 1:length(NorthAmerica_SNOW_files)) {
  
  temp_rast <- raster(NorthAmerica_SNOW_files[i])
  
  file_name <- substr(filename(temp_rast),121,157) 
  year <- substr(filename(temp_rast),129,132)
  
  temp_rast <- projectRaster(temp_rast, reference_raster)
  
  writeRaster(temp_rast, filename = paste0("./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MYD10A2/2_8days_Mosaics_LAEA_250m/",
                                           year, "/", file_name, "_laea_mosaic.tif"), datatype='INT4S', overwrite = T)
  
  removeTmpFiles(h=0.01)
  
} 

