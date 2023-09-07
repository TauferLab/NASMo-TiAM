#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #3. Generation of Biweekly Training and Prediction matrices

###3.1.3 North America biweekly training matrices split 

#This code randomly splits North America training files in 70% and 30 % 
#for training the models and for later test.

##########

setwd("D:/3_North_America_SM_predictions")

##########

years <- c("2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

biweeks <- c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23")

training_files <- list.files(path = "./3_Training_and_Test_data_csv/1_northamerica",
                             pattern = ".csv", recursive = TRUE, full.names = TRUE)

for (p in 1:length(training_files)) {
  
  x <- read.csv(training_files[p])
  
  biweek_name <- substr(training_files[p], 82, 88) 
  
  ## 70% of the sample size
  smp_size <- floor(0.70 * nrow(x))
  
  ## set the seed to make your partition reproducible
  train_ind <- sample(seq_len(nrow(x)), size = smp_size)
  
  train <- x[train_ind, ]
  test <- x[-train_ind, ]
  
  write.csv(train, paste0("./3_Training_and_Test_data_csv/2_northamerica_train_70pct/northamerica_train_v71_250m_70pct_",
                          biweek_name, "__.csv"), row.names = FALSE)
  
  write.csv(test, paste0("./3_Training_and_Test_data_csv/3_northamerica_test_30pct/northamerica_test_v71_250m_30pct_", 
                         biweek_name, "__.csv"), row.names = FALSE)
  
  print(paste0(p, "  ", biweek_name))
  
}
