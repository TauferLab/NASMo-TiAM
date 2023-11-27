#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.5.2	Land Surface Temperature North America Mosaics

#This section of the process takes the MOD11A2 and MYD11A2 LST tiles in TIF format and 
#assembles a mosaic for the North America region in the native Sinusoidal projection. 
#Then reprojects and resamples the mosaics.

##Libraries
library(raster)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("E:/3_North_America_SM_predictions")

##########

#LST Mosaics

years <- c("2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

weeks <- c("001","009","017","025","033","041","049","057","065",
           "073","081","089","097","105","113","121","129","137",
           "145","153","161","169","177","185","193","201","209",
           "217","225","233","241","249","257","265","273","281",
           "289","297","305","313","321","329","337","345","353","361")

##MOD11A2##

for (i in 1:length(years)) {
  for (j in 1:length(weeks)) {
    
    lst_tif_files <- list.files(path = paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MOD11A2/0_8days_tif_tiles/",
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
      
      base_raster <- base_raster*0.02
      
      writeRaster(base_raster, filename = paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MOD11A2/1_8days_Mosaics_sinusoidal/",
                                                 years[i], "/MOD11A2_", years[i], weeks[j], "_NorthAmerica_061_lst_mosaic.tif"), 
                  datatype='INT4S', overwrite = T)
      
      removeTmpFiles(h=0.01)
      
    }
  }
}


##MYD11A2##

for (i in 1:length(years)) {
  for (j in 1:length(weeks)) {
    
    lst_tif_files <- list.files(path = paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MYD11A2/0_8days_tif_tiles/",
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
      
      base_raster <- base_raster*0.02
      
      writeRaster(base_raster, filename = paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MYD11A2/1_8days_Mosaics_sinusoidal/",
                                                 years[i], "/MYD11A2_", years[i], weeks[j], "_NorthAmerica_061_lst_mosaic.tif"), 
                  datatype='INT4S', overwrite = T)
      
      removeTmpFiles(h=0.01)
      
    }
  }
}


##########

#Reprojection and resampling of North America LST mosaics from Sinusoidal 
#projection to LAEA projection and 250 meters cell size  
#*This process works in R but takes a long time, so it was performed in ArcPro.

reference_raster <- raster("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/NA_LandCover_2010_V2_25haMMU.tif")

#MOD11A2

NorthAmerica_LST_files <- list.files(path = "./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MOD11A2/1_8days_Mosaics_sinusoidal", 
                                      pattern = "lst_mosaic.tif", full.names = T, recursive = T)

for (i in 1:length(NorthAmerica_LST_files)) {
  
  temp_rast <- raster(NorthAmerica_LST_files[i])
  
  file_name <- substr(filename(temp_rast),120,155) 
  year <- substr(filename(temp_rast),128,131)
  
  temp_rast <- projectRaster(temp_rast, reference_raster)
  
  writeRaster(temp_rast, filename = paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MOD11A2/2_8days_Mosaics_LAEA_250m/",
                                           year, "/", file_name, "_laea_mosaic.tif"), datatype='INT4S', overwrite = T)
  
  removeTmpFiles(h=0.01)
  
}


#MYD11A2

NorthAmerica_LST_files <- list.files(path = "./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MYD11A2/1_8days_Mosaics_sinusoidal", 
                                      pattern = "lst_mosaic.tif", full.names = T, recursive = T)

for (i in 1:length(NorthAmerica_LST_files)) {
  
  temp_rast <- raster(NorthAmerica_LST_files[i])
  
  file_name <- substr(filename(temp_rast),120,155) 
  year <- substr(filename(temp_rast),128,131)
  
  temp_rast <- projectRaster(temp_rast, reference_raster)
  
  writeRaster(temp_rast, filename = paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MYD11A2/2_8days_Mosaics_LAEA_250m/",
                                           year, "/", file_name, "_laea_mosaic.tif"), datatype='INT4S', overwrite = T)
  
  removeTmpFiles(h=0.01)
  
} 

