#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #3. Generation of Biweekly Training and Prediction matrices

###3.1.2 Union of all regional biweekly training files into North America training files 

#This code takes the csv training matrices of the 14 sub-regions per biweekly period 
#and aggregates them into North American training matrices.

##########

setwd("D:/3_North_America_SM_predictions")

##########

years <- c("2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

biweeks <- c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23")

for (m in 1:length(years)) {
  
  csv_year_files_list <- list.files(path = "./3_Training_and_Test_data_csv/0_regions", 
                                    pattern = paste0("v71_250m_", years[m]), recursive = TRUE, full.names = TRUE)
  
  for (k in 1:length(biweeks)) {
    
    csv_week_files_list <- csv_year_files_list[grep(paste0(biweeks[k], ".csv"), csv_year_files_list)]
    
    if(length(csv_week_files_list) <= 1){
      
      print(paste0(years[m], "  ", biweeks[k], "  Biweek with no files"))
      
    } else {
      
      temp_table_base <- read.csv(csv_week_files_list[1], header = T)
      
      for (n in 2:length(csv_week_files_list)) {
        
        temp_table <- read.csv(csv_week_files_list[n], header = T)
        
        temp_table_base <- rbind(temp_table_base, temp_table)
        
        print(n)
        
      }  
      
      write.csv(temp_table_base, file=paste0("./3_Training_and_Test_data_csv/1_northamerica/northamerica_train_matrix_v71_250m_", years[m], "_", biweeks[k], "__.csv"), row.names = F)
      
      print(paste0(years[m], "  ", biweeks[k], "  Done"))
      
    }
  }
}
