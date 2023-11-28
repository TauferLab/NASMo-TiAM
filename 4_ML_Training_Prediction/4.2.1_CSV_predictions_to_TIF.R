#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #4. Prediction of Soil Moisture biweekly layers for North America

###4.2.1	Mosaic of predicted North America Soil Moisture raster files

#This code transforms the outputs of the Random Forest predictions from points to pixels in 
#raster format. The code uses the preprocessed North America elevation raster file as reference 
#and creates raster files in TIF format with the same coordinate reference system and pixel 
#size as the reference. The outputs are up to 44 raster files per biweekly period, 
#coinciding with the 44 predefined regions in the creation of the prediction matrices.

##Libraries
library(raster)
library(doParallel)
library(foreach)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("E:/3_North_America_SM_predictions")

##########

predicted_files <- list.files("./5_NorthAmerica_prediction_outputs_250m_v71/2_RF/Prediction_outputs", 
                              pattern = ".csv", full.names = T, recursive = T)

ref_250m <- raster("E:/3_North_America_SM_predictions/2_Covariates/1_static_covariates/NorthAmerica_wgs84_250m_elevation.tif")


years <- c("2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

biweeks <- c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23")

for (i in 1:length(years)) {
  
  predicted_files_year <- predicted_files[grep(paste0("/", years[i], "/"), predicted_files)]
  
  for (j in 1:length(biweeks)) {
    
    predicted_files_biweek <- predicted_files_year[grep(paste0("/", biweeks[j], "/"), predicted_files_year)]
    
    UseCores <- detectCores() -2
    cl <- makeCluster(UseCores)
    registerDoParallel(cl)
    
    foreach (k = 1:length(predicted_files_biweek)) %dopar% {
      
      library(raster)
      
      predicted_file <- read.csv(predicted_files_biweek[k], header = T)
      
      year <- substr(predicted_files_biweek[k], 113, 116)
      biweek <- substr(predicted_files_biweek[k], 118, 119)
      region <- substr(predicted_files_biweek[k], 121, 129)
      
      r <- SpatialPointsDataFrame(predicted_file[,1:2],predicted_file) 
      crs(r) <- "+proj=longlat +datum=WGS84 +no_defs"
      
      r <- rasterize(r, ref_250m, field=r$sm, fun=mean, background=NA)
      
      writeRaster(r, filename = paste0("./5_NorthAmerica_prediction_outputs_250m_v71/2_RF/Prediction_outputs_tif/1_Regions/", 
                                       year,"/",biweek,"/northamerica_rf_v71_250m_output_sm_",year,"_",biweek,"_",region,".tif"), overwrite = TRUE)
      
      gc() 
      removeTmpFiles(h=0.01)
      
      print(paste0(year, "  ", biweek, "  ", region))
      
    }
    
    stopCluster(cl)
  }
}
