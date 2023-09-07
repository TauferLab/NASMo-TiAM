#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.7.2 Calculation of NASMD biweekly means

#This code reads all the daily values from the preselected NAMSD and calculates biweekly 
#mean values from 2002 to 2020 per station. Then creates a set of CSV files per biweekly 
#periods, containing all the available stations in each period, their location and mean
#soil moisture values.

##Libraries
library(dplyr)
##########

setwd("D:/3_North_America_SM_predictions")

##########

#Calculation of biweekly mean values per station 

stations_files <- list.files(path = "./1_Preprocessed_data/7_NASMD_validation/2_nasmd_readings_2002_2020",
                            pattern = ".csv",  recursive = TRUE, full.names = TRUE)

years <- c("2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

biweeks <- c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23")

biweeks_start_day <- c(1,17,33,49,65,81,97,113,129,145,161,177,193,209,225,241,257,273,289,305,321,337,353)
biweeks_end_day  <- c(16,32,48,64,80,96,112,128,144,160,176,192,208,224,240,256,272,288,304,320,336,352,365)


for (i in 1:length(stations_files)) {
  
  biweekly_records_base <- matrix(data = NA, nrow = 0, ncol = 6)
  biweekly_records_base <- as.data.frame(biweekly_records_base)
  names(biweekly_records_base) <- c("Station_ID", "Latitude", "Longitude", "Year", "Biweek", "mean_sm_depth_5cm")
    
  station_records <- read.csv(stations_files[[i]])
  
  for (j in 1:length(years)) {
  
    station_records_year <- subset(station_records, station_records$Year == years[j])  
  
    for (k in 1:length(biweeks_start_day)) {

      biweekly_records <- subset(station_records_year, station_records_year$DOY >= biweeks_start_day[k] 
                                 & station_records_year$DOY <= biweeks_end_day[k])
  
      biweekly_records_temp <- matrix(data = NA, nrow = 1, ncol = 6)
      biweekly_records_temp <- as.data.frame(biweekly_records_temp)
      names(biweekly_records_temp) <- c("Station_ID", "Latitude", "Longitude", "Year", "Biweek", "mean_sm_depth_5cm")
      
      
      biweekly_records_temp$Station_ID <- mean(station_records$Station_ID)
      biweekly_records_temp$Latitude <- mean(station_records$Latitude)
      biweekly_records_temp$Longitude <- mean(station_records$Longitude)
      biweekly_records_temp$Year <- years[j]
      biweekly_records_temp$Biweek <- biweeks[k]
      biweekly_records_temp$mean_sm_depth_5cm <- mean(biweekly_records$sm_depth_5cm)
        
      biweekly_records_base <- rbind(biweekly_records_base, biweekly_records_temp)
      
      print(paste0(i, "  Station  ", mean(station_records$Station_ID), "  ", years[j], "  ", biweeks[k]))
        
    }
  }
  
  biweekly_records_base <- na.omit(biweekly_records_base)
  biweekly_records_base$mean_sm_depth_5cm <- round(biweekly_records_base$mean_sm_depth_5cm, digits = 6)
  write.csv(biweekly_records_base, paste0("./1_Preprocessed_data/7_NASMD_validation/3_nasmd_stations_biweekly_means/",
                                          mean(station_records$Station_ID), "_nasmd_biweekly_means_2002_2020.csv"), 
                                          row.names = FALSE)
  
}
  

##########

#Generation of biweekly tables including all available stations per period

list_stations_files <- list.files(path = "./1_Preprocessed_data/7_NASMD_validation/3_nasmd_stations_biweekly_means",
                             pattern = ".csv",  recursive = TRUE, full.names = TRUE)

years <- c(2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020)

biweeks <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)

base_table <- read.csv(list_stations_files[[1]])
 
for (i in 2:length(list_stations_files)) {
  
  temp_table <- read.csv(list_stations_files[[i]])
  
  base_table <- rbind(base_table, temp_table)
  
  print(i)
  
}

for (j in 1:length(years)) {
  
  temp_year <- subset(base_table, base_table$Year == years[j])
  
  for (k in 1:length(biweeks)) {
    
    temp_week <- subset(temp_year, temp_year$Biweek == biweeks[k])
    
    if(nrow(temp_week) > 0) {
      
        write.csv(temp_week, paste0("./1_Preprocessed_data/7_NASMD_validation/4_nasmd_biweekly_means_northamerica/",
                                    "nasmd_biweekly_mean_sm_", years[j], "_", biweeks[k], ".csv"), row.names = FALSE)
        
          print(paste0(years[j], "  ", biweeks[k]))
    
    }
  }
}

