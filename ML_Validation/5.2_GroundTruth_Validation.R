#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #5.	Validation

###5.2	5.2	Independent Validation with Ground-Truth Data

#This code calculates correlation and root mean square error (RMSE) values based 
#on matrices containing the predicted values and reference soil moisture records 
#from the North American Soil Moisture Database (NASMD). To obtain reference 
#correlation and RMSE values, the code also compares the input ESA-CCI soil 
#moisture values with field records from NASMD.

##Libraries
library(raster)
library(Metrics)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("F:/3_North_America_SM_predictions")

##########

#Ground-Truth Validation (Reference ESA CCI Soil Moisture VS NASMD values) 

years_file <- c("_2002_","_2003_","_2004_","_2005_","_2006_","_2007_","_2008_","_2009_","_2010_",
                "_2011_","_2012_","_2013_","_2014_","_2015_","_2016_","_2017_","_2018_","_2019_","_2020_")

biweeks_file <- c("_01.","_02.","_03.","_04.","_05.","_06.","_07.","_08.","_09.","_10.","_11.","_12.",
                  "_13.","_14.","_15.","_16.","_17.","_18.","_19.","_20.","_21.","_22.","_23.")

years <- c("2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

biweeks <- c("01","02","03","04","05","06","07","08","09","10","11","12",
             "13","14","15","16","17","18","19","20","21","22","23")

raster_files <- list.files(path = "D:/3_North_America_SM_predictions/2_Covariates/0_esacci_soil_moisture",
                           pattern = ".tif", full.names = TRUE, recursive = TRUE)

nasmd_files <- list.files(path = "D:/3_North_America_SM_predictions/1_Preprocessed_data/7_NASMD_validation/4_nasmd_biweekly_means_northamerica",
                          pattern = ".csv", full.names = TRUE, recursive = TRUE)

validation_report_final <- matrix(data = NA, nrow = 0, ncol = 8)
validation_report_final <- as.data.frame(validation_report_final)
names(validation_report_final) <- c("Region", "Method", "Resolution", "Year", "Biweek", "No.Points", "Correl", "RMSE")

for (i in 1:length(years)) {
  
  raster_files_year <- raster_files[grep(years_file[i], raster_files)]
  nasmd_files_year <- nasmd_files[grep(years_file[i], nasmd_files)]
  
  for (j in 1:length(biweeks)) {
    
    raster_file_biweek <- raster_files_year[grep(biweeks_file[j], raster_files_year)]
    raster_file_biweek <- as.list(raster_file_biweek)
    nasmd_file_biweek <- nasmd_files_year[grep(biweeks_file[j], nasmd_files_year)]
    nasmd_file_biweek <- as.list(nasmd_file_biweek)
    
    if(length(raster_file_biweek) > 0 & length(nasmd_file_biweek) > 0) {
      
      x <- raster(raster_file_biweek[[1]])
      
      validation_data <- read.csv(nasmd_file_biweek[[1]], header = TRUE, dec = ".")
      validation_data <- as.data.frame(cbind(validation_data$Longitude, validation_data$Latitude, validation_data$mean_sm_depth_5cm))
      validation_data$Year <- years[i]
      validation_data$Biweek <- biweeks[j]
      validation_data$Region <- "North America"
      validation_data$Method <- "ESACCI_reference"
      validation_data$Resolution <- "0.25 deg"
      names(validation_data) <- c("X","Y","NASMD_SM","Year","Biweek", "Region", "Method", "Resolution")
      
      validation_data <- as.data.frame(validation_data, xy=TRUE)
      xy_ <- validation_data[,c(1,2)]
      
      validation_data <- SpatialPointsDataFrame(coords = xy_, data = validation_data,
                                                proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
      
      validation_output <- extract(x, validation_data)
      
      validation_data_table <- as.data.frame(validation_data)
      validation_data_table <- cbind(validation_data_table, validation_output)
      validation_data_table <- as.data.frame(validation_data_table)
      validation_data_table <- na.omit(validation_data_table)
      
      final_validation_file <- as.data.frame(cbind(validation_data_table$X, validation_data_table$Y, validation_data_table$Year,
                                                   validation_data_table$Biweek, validation_data_table$NASMD_SM,
                                                   validation_data_table$validation_output, validation_data_table$Region,
                                                   validation_data_table$Method, validation_data_table$Resolution))
      
      names(final_validation_file) <- c("X","Y","Year","Biweek","NASMD_ref","ESACCI_SM","Region","Method","Resolution")
      
      final_validation_file$NASMD_ref <- as.numeric(as.character(final_validation_file$NASMD_ref))
      final_validation_file$ESACCI_SM <- as.numeric(as.character(final_validation_file$ESACCI_SM))
      
      write.csv(final_validation_file, file = paste0("./5_NorthAmerica_prediction_outputs_250m_v71/3_Validation_reports/2_Ground_truth_validation/1_ESACCI_reference/",
                                                     years[i], "/northamerica_esacci_v71_250m_groundtruth_validation_", 
                                                     years[i], "_", biweeks[j], ".csv"))
      
      
      validation_report_temp <- matrix(data = NA, nrow = 0, ncol = 8)
      validation_report_temp <- as.data.frame(validation_report_temp)
      names(validation_report_temp) <- c("Region", "Method", "Resolution", "Year", "Biweek", "No.Points", "Correl", "RMSE")
      
      validation_report_temp[1,1] <- "North America"
      validation_report_temp[1,2] <- "ESACCI_reference"
      validation_report_temp[1,3] <- "0.25 deg"
      validation_report_temp[1,4] <- years[i]
      validation_report_temp[1,5] <- biweeks[j]
      validation_report_temp[1,6] <- length(final_validation_file$Year)
      validation_report_temp[1,7] <- cor(final_validation_file$NASMD_ref, final_validation_file$ESACCI_SM, use = "pairwise.complete.obs")
      validation_report_temp[1,8] <- rmse(final_validation_file$NASMD_ref, final_validation_file$ESACCI_SM)
      
      validation_report_final <- rbind(validation_report_final, validation_report_temp)
      
      print(paste0(years[i], "  ", biweeks[j]))
      
    }
  }
}

write.csv(validation_report_final, file = paste0("./5_NorthAmerica_prediction_outputs_250m_v71/3_Validation_reports/2_Ground_truth_validation/1_ESACCI_reference/",
                                                 "northamerica_esacci_v71_250m_groundtruth_validation.csv"))


##########

#Ground-Truth Validation (Soil Moisture predicted values VS NASMD values) 

raster_files <- list.files(path = "./5_NorthAmerica_prediction_outputs_250m_v71/2_RF/Prediction_outputs_tif/2_NA_mosaics",
                           pattern = ".tif", full.names = TRUE, recursive = TRUE)

nasmd_files <- list.files(path = "D:/3_North_America_SM_predictions/1_Preprocessed_data/7_NASMD_validation/4_nasmd_biweekly_means_northamerica",
                         pattern = ".csv", full.names = TRUE, recursive = TRUE)

validation_report_final <- matrix(data = NA, nrow = 0, ncol = 8)
validation_report_final <- as.data.frame(validation_report_final)
names(validation_report_final) <- c("Region", "Method", "Resolution", "Year", "Biweek", "No.Points", "Correl", "RMSE")

for (i in 1:length(years)) {
  
  raster_files_year <- raster_files[grep(years_file[i], raster_files)]
  nasmd_files_year <- nasmd_files[grep(years_file[i], nasmd_files)]
  
  for (j in 1:length(biweeks)) {
    
    raster_file_biweek <- raster_files_year[grep(biweeks_file[j], raster_files_year)]
    raster_file_biweek <- as.list(raster_file_biweek)
    nasmd_file_biweek <- nasmd_files_year[grep(biweeks_file[j], nasmd_files_year)]
    nasmd_file_biweek <- as.list(nasmd_file_biweek)
    
    if(length(raster_file_biweek) > 0 & length(nasmd_file_biweek) > 0) {
      
    x <- raster(raster_file_biweek[[1]])
    
    validation_data <- read.csv(nasmd_file_biweek[[1]], header = TRUE, dec = ".")
    validation_data <- as.data.frame(cbind(validation_data$Longitude, validation_data$Latitude, validation_data$mean_sm_depth_5cm))
    validation_data$Year <- years[i]
    validation_data$Biweek <- biweeks[j]
    validation_data$Region <- "North America"
    validation_data$Method <- "RF"
    validation_data$Resolution <- "250m"
    names(validation_data) <- c("X","Y","NASMD_SM","Year","Biweek", "Region", "Method", "Resolution")
    
    validation_data <- as.data.frame(validation_data, xy=TRUE)
    xy_ <- validation_data[,c(1,2)]
    
    validation_data <- SpatialPointsDataFrame(coords = xy_, data = validation_data,
                                              proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
    
    validation_output <- extract(x, validation_data)

    validation_data_table <- as.data.frame(validation_data)
    validation_data_table <- cbind(validation_data_table, validation_output)
    validation_data_table <- as.data.frame(validation_data_table)
    validation_data_table <- na.omit(validation_data_table)
    
    final_validation_file <- as.data.frame(cbind(validation_data_table$X, validation_data_table$Y, validation_data_table$Year,
                                                 validation_data_table$Biweek, validation_data_table$NASMD_SM,
                                                 validation_data_table$validation_output, validation_data_table$Region,
                                                 validation_data_table$Method, validation_data_table$Resolution))
    
    names(final_validation_file) <- c("X","Y","Year","Biweek","NASMD_ref","SoilMoist_Pred","Region","Method","Resolution")
    
    final_validation_file$NASMD_ref <- as.numeric(as.character(final_validation_file$NASMD_ref))
    final_validation_file$SoilMoist_Pred <- as.numeric(as.character(final_validation_file$SoilMoist_Pred))
    
    write.csv(final_validation_file, file = paste0("./5_NorthAmerica_prediction_outputs_250m_v71/3_Validation_reports/2_Ground_truth_validation/2_RandomForest_predictions/",
                                                   years[i], "/northamerica_rf_v71_250m_groundtruth_validation_", 
                                                   years[i], "_", biweeks[j], ".csv"))
    
    
    validation_report_temp <- matrix(data = NA, nrow = 0, ncol = 8)
    validation_report_temp <- as.data.frame(validation_report_temp)
    names(validation_report_temp) <- c("Region", "Method", "Resolution", "Year", "Biweek", "No.Points", "Correl", "RMSE")

    validation_report_temp[1,1] <- "North America"
    validation_report_temp[1,2] <- "RF"
    validation_report_temp[1,3] <- "250m"
    validation_report_temp[1,4] <- years[i]
    validation_report_temp[1,5] <- biweeks[j]
    validation_report_temp[1,6] <- length(final_validation_file$Year)
    validation_report_temp[1,7] <- cor(final_validation_file$NASMD_ref, final_validation_file$SoilMoist_Pred, use = "pairwise.complete.obs")
    validation_report_temp[1,8] <- rmse(final_validation_file$NASMD_ref, final_validation_file$SoilMoist_Pred)
    
    validation_report_final <- rbind(validation_report_final, validation_report_temp)
    
    print(paste0(years[i], "  ", biweeks[j]))
    
    }
  }
}

    write.csv(validation_report_final, file = paste0("./5_NorthAmerica_prediction_outputs_250m_v71/3_Validation_reports/2_Ground_truth_validation/2_RandomForest_predictions/",
                                           "northamerica_rf_v71_250m_groundtruth_validation.csv"))
    
