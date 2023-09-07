#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #4.	Prediction of Soil Moisture biweekly layers for North America

###4.2.2	Mosaic of predicted North America Soil Moisture raster files

#This section of the process takes all the raster files of the predicted soil moisture 
#over the 44 sub-regions of interest and assembles a mosaic for North America.

##Libraries
library(raster)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("F:/3_North_America_SM_predictions")

##########

#Soil Moisture Mosaics
#*This process works in R but takes a long time, so I performed this in Arc Pro.

years <- c("2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

biweeks <- c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23")

for (i in 1:length(years)) {
  for (j in 1:length(biweeks)) {
    
      sm_regions_tif <- list.files(path = paste0("./5_NorthAmerica_prediction_outputs_250m_v71/2_RF/Prediction_outputs_tif/1_Regions/",
                                               years[i],"/", biweeks[j]), pattern = ".tif", full.names = T, recursive = T)
    
      sm_regions_tif <- lapply(sm_regions_tif, raster)
      
      base_raster <- sm_regions_tif[[1]]
      
      for (k in 2:length(sm_regions_tif)) {
        
        temp_raster <- sm_regions_tif[[k]]
        
        base_raster <- mosaic(base_raster, temp_raster, fun = mean)
        
        plot(base_raster)
        
        print(paste0(years[i], "  ", biweeks[j], "  ", k))
        
      }
      
      writeRaster(base_raster, filename = paste0("./5_NorthAmerica_prediction_outputs_250m_v71/2_RF/Prediction_outputs_tif/2_NA_mosaics/",
                                                 years[i], "/northamerica_rf_v71_250m_output_sm_", years[i], "_", biweeks[j],
                                                 ".tif"), overwrite = T)
      
      removeTmpFiles(h=0.01)
      
    }
  }

