#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #5.	Validation

###5.1	Cross-Validation with Reference Satellite-Derived Soil Moisture Data

#This code calculates correlation and root mean square error (RMSE) values based on 
#matrices containing the predicted and reference soil moisture values (from ESA-CCI data). 
#The input data for cross-validation corresponds with 30% of the sampling points set 
#aside during the generation of the training matrices.

##Libraries
library(raster)
library(Metrics)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("F:/3_North_America_SM_predictions")

##########

raster_files <- list.files(path = "./5_NorthAmerica_prediction_outputs_250m_v71/2_RF/Prediction_outputs_tif/2_NA_mosaics",
                           pattern = ".tif", full.names = TRUE, recursive = TRUE)

test_files <- list.files(path = "D:/3_North_America_SM_predictions/3_Training_and_Test_data_csv/3_northamerica_test_30pct",
                         pattern = ".csv", full.names = TRUE, recursive = TRUE)

validation_report <- matrix(data = NA, nrow = length(raster_files), ncol = 8)
validation_report <- as.data.frame(validation_report)
names(validation_report) <- c("Region", "Method", "Resolution", "Year", "Biweek", "No.Points", "Correl", "RMSE")

for (i in 1:length(raster_files)) {
  
  x <- raster(raster_files[i])
  
  year <- substr(raster_files[i], 127, 130)
  biweek <- substr(raster_files[i], 132, 133)   
  
  validation_data <- read.csv(test_files[i], header = TRUE, dec = ".")
  validation_data <- as.data.frame(cbind(validation_data$x, validation_data$y, validation_data$z))
  validation_data$Year <- year
  validation_data$Biweek <- biweek
  validation_data$Region <- "North America"
  validation_data$Method <- "RF"
  validation_data$Resolution <- "250m"
  names(validation_data) <- c("X","Y","ESACCI_SM","Year","Biweek", "Region", "Method", "Resolution")
  
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
                                               validation_data_table$Biweek, validation_data_table$ESACCI_SM,
                                               validation_data_table$validation_output, validation_data_table$Region,
                                               validation_data_table$Method, validation_data_table$Resolution))
  
  names(final_validation_file) <- c("X","Y","Year","Biweek","ESACCI_ref","SoilMoist_Pred","Region","Method","Resolution")
  
  final_validation_file$ESACCI_ref <- as.numeric(as.character(final_validation_file$ESACCI_ref))
  final_validation_file$SoilMoist_Pred <- as.numeric(as.character(final_validation_file$SoilMoist_Pred))
  
  write.csv(final_validation_file, file = paste0("./5_NorthAmerica_prediction_outputs_250m_v71/3_Validation_reports/1_Cross_validation/",
                                                 year, "/northamerica_rf_v71_250m_validation_test30pct_", year, "_", biweek, ".csv"))
  
  validation_report[i,1] <- "North America"
  validation_report[i,2] <- "RF"
  validation_report[i,3] <- "250m"
  validation_report[i,4] <- year
  validation_report[i,5] <- biweek
  validation_report[i,6] <- length(final_validation_file$Year)
  validation_report[i,7] <- cor(final_validation_file$ESACCI_ref, final_validation_file$SoilMoist_Pred, use = "pairwise.complete.obs")
  validation_report[i,8] <- rmse(final_validation_file$ESACCI_ref, final_validation_file$SoilMoist_Pred)
  
  print(paste0(year, "  ", biweek))
  
}

write.csv(validation_report, file = paste0("./5_NorthAmerica_prediction_outputs_250m_v71/3_Validation_reports/1_Cross_validation/",
                                            "northamerica_rf_v71_250m_validation_test30pct.csv"))

gc() 
removeTmpFiles(h=0.01)

