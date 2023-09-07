#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.7.1	NASMD stations and records sub setting

#This section of the code imports and preprocesses the soil moisture ground-truth records 
#from the North American Soil Moisture Database (NASMD) that are densely distributed across 
#the Conterminous United States and Alaska, with fewer extra points in Canada.

#This first part of the script generates a list of all NASMD stations, including coordinates 
#and basic information to be used in the creation of a points-shapefile that allows intersect 
#the NASDMD station with tin the North America region of interest. Most of the stations folders 
#provide three files related to station’s location information, depths at which soil moisture 
#was measured, and soil moisture records. The code only selects those stations with the complete 
#set of three information files. Once the set of NASMD stations within the region of interest 
#is defined, the code imports the records for each station and creates new CSV files keeping 
#only the soil moisture measurements referring to 5-cm depth or less, removes all invalid 
#records and keep valid ones from 2002 and 2020.

##Libraries
library(dplyr)
##########

setwd("D:/3_North_America_SM_predictions")

##########

#List of NASMD stations and coordinates 

folders <- list.dirs(path = "./0_Input_data/7_NASMD_validation/1_nasmd_readings_files")

stations_coordinates_final <- tibble(Station_code = numeric(), Network = character(), State = character(),
                                     Longitude = numeric(), Latitude = numeric(), Elevation = numeric(),
                                     Start_year = numeric(), End_year = numeric())

for (i in 2:length(folders)){ 
  
  filez <- list.files(paste(folders[i], sep=""), pattern="\\.txt$") 
  
  stations = paste(folders[i],"/",filez[3], sep='')
  
  if(length(filez)==3){ 
    
    stations=read.table(stations, sep='\t', header=T, fill=T)
    
    station_ID <- as.character(stations$StationID)
    Network <- as.character(stations$Network) 
    State <- as.character(stations$State)
    Longitude <- as.numeric(stations$Longitude)
    Latitude <- as.numeric(stations$Latitude)
    Elevation <- as.numeric(stations$Elevation)
    Start_year <- as.numeric(stations$StartYear)
    End_year <- as.numeric(stations$EndYear)
    
    stations_coordinates_temp <- tibble(Station_code = station_ID, Network = Network, State = State,
                                        Longitude = Longitude, Latitude = Latitude, Elevation = Elevation,
                                        Start_year = Start_year, End_year = End_year) 
    
    stations_coordinates_final <- rbind(stations_coordinates_final, stations_coordinates_temp)
    
    print(i)
    
  }
}

write.csv(stations_coordinates_final, 
          file = './1_Preprocessed_data/7_NASMD_validation/nasmd_validation_stations_coordinates.csv')


##########
#Next part of the process is to create a shapefile with the list of NASMD and their coordinates, 
#and subset the stations that intersect the North America region of interest.


##########
#List of NASMD stations and coordinates 
#Generation of csv files containing the readings of the NASMD stations at 5cm depth that have 
#valid data from 2002 to 2020.

folders <- list.dirs(path = "./1_Preprocessed_data/7_NASMD_validation/1_nasmd_northamerica_selected_stations")

Start_End_Years <- data.frame(Station_ID = numeric(), Start_Year = numeric(), End_Year = numeric())

for (i in 2:length(folders)){ 
  
  filez <- list.files(paste(folders[i],sep=""),pattern="\\.txt$") 
  
  stations = paste(folders[i],"/",filez[3],sep="") 
  
  if(length(filez)==3){ 
    
    stations = read.table(stations, sep='\t', header=T, fill=T) 
    
    xy = stations[,8:7] 
    print(xy) 
    
    readings = paste(folders[i],"/",filez[2],sep="") 
    
    readings = read.table(readings, sep='\t', header=T)
    
    
    m=merge(readings, xy)
    
    m <- subset(m, m$Y < 2021)
    m <- subset(m, m$Y > 2001)
    m <- subset(m, m$depth_5 != -9999)
    
    sm_station <- data.frame(Station_ID = m$stationID, Latitude = m$Latitude, Longitude = m$Longitude, Year = m$Y, Month = m$M, 
                             Day = m$D, DOY = m$DOY, sm_depth_5cm = m$depth_5)
    
    name_station <- as.character(sm_station[1,1])
    
    write.csv(sm_station, file = paste0("./1_Preprocessed_data/7_NASMD_validation/2_nasmd_readings_2002_2020/",
                                        name_station, '_nasmd_records_2002_2020_5cm_depth__.csv'), row.names = FALSE)
    
    print(i)
    
  }
} 

