#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #3. Generation of Biweekly Training and Prediction matrices

###3.2.1 Generation of North America prediction matrices by predefined sub-regions

#This code creates the prediction matrices for every biweekly period for 44 sub-regions of interest. 
#The matrices depict the values of the dynamic and static covariates for each biweekly period in 
#the centroid coordinates of all 250 meters pixels within each sub-region.

#The code imports the dynamic covariates (NDVI and LST), and the dynamic masks (Snow Cover) in fine 
#resolution (250 meters) for ever biweekly period. The static covariates (terrain parameters and bulk 
#density) are also imported. The set of imported layers are temporarily stored in a raster stack and 
#then masked with the Snow Cover layer to remove snow and ice-covered areas from the output 
#prediction matrices.

##Libraries
library(raster)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("E:/3_North_America_SM_predictions")

##########

biweeks <- c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23")

regions_list <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", 
                  "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", 
                  "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", 
                  "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44")

regions_sections <- as.list(c("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_01.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_02.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_03.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_04.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_05.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_06.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_07.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_08.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_09.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_10.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_11.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_12.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_13.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_14.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_15.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_16.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_17.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_18.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_19.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_20.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_21.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_22.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_23.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_24.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_25.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_26.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_27.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_28.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_29.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_30.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_31.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_32.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_33.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_34.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_35.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_36.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_37.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_38.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_39.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_40.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_41.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_42.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_43.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_eval_fishnet/northamerica_eval_fishnet_wgs84_44.shp"))

#Import of static covariates (elevation, aspect, slope, twi, bulk density)

ndvi_northamerica_files <- list.files(path = "./2_Covariates/2_dinamyc_covariates/NDVI", pattern = "tif", recursive = TRUE, full.names = TRUE)
ndvi_northamerica_files <- as.list(ndvi_northamerica_files)

lst_northamerica_files <- list.files(path = "./2_Covariates/2_dinamyc_covariates/LST", pattern = "tif", recursive = TRUE, full.names = TRUE)
lst_northamerica_files <- as.list(lst_northamerica_files)

snow_masks_northamerica_files <- list.files(path = "./2_Covariates/3_masks/SNOW", pattern = "tif", recursive = TRUE, full.names = TRUE)
snow_masks_northamerica_files <- as.list(snow_masks_northamerica_files)

static_covariates <- list.files(path = "./2_Covariates/1_static_covariates", pattern = "tif", recursive = TRUE, full.names = TRUE)

###

static_covariates <- as.list(static_covariates[1:16])
static_covariates <- static_covariates[c(7,2,12,14,13)]

elevation <- raster(static_covariates[[1]])
aspect <- raster(static_covariates[[2]])
slope <- raster(static_covariates[[3]])
twi <- raster(static_covariates[[4]])
bulkdensity <- raster(static_covariates[[5]])
static_covariates <- stack(elevation, aspect, slope, twi, bulkdensity)


for (j in 1:length(regions_list)) {
  
  temp_boundary <- shapefile(regions_sections[[j]])
  
  for (i in 1:length(ndvi_northamerica_files)) {
    
    year <- substr(ndvi_northamerica_files[i], 90, 93)
    biweek <- substr(ndvi_northamerica_files[i], 102, 103)
    
    base_table <- matrix(data = NA, nrow = 0, ncol = 9)
    base_table <- as.data.frame(base_table)
    names(base_table) <- c("x","y","ndvi","lst","elevation","aspect","slope","twi","bulk_density")
    
    #Region Subset
    region_static_covariates <- crop(static_covariates, temp_boundary)
    
    ndvi <- raster(ndvi_northamerica_files[[i]])
    ndvi <- crop(ndvi, temp_boundary)
    ndvi <- resample(ndvi, region_static_covariates)
    
    lst <- raster(lst_northamerica_files[[i]])
    lst <- crop(lst, temp_boundary)
    lst <- resample(lst, region_static_covariates)
    
    snow_mask <- raster(snow_masks_northamerica_files[[i]])
    snow_mask <- crop(snow_mask, temp_boundary)
    snow_mask <- resample(snow_mask, region_static_covariates)
    
    x <- stack(ndvi, lst, region_static_covariates)
    
    x <- x * snow_mask
    
    #This checks for regions where no data is available on specific biweekly periods and skips the process 
    empty_frame_check <- cellStats(x, stat = 'mean')
    
    if(mean(empty_frame_check) == "NaN"){
      
      print(paste0(year, " ", biweek, " ", "Empty frame"))
      
    } else {
      
      #convert to spatial pixels data frame
      x<- as(x,'SpatialPixelsDataFrame')
      
      names(x) <- c("ndvi","lst","elevation","aspect","slope","twi","bulk_density")
      
      eval_file <- as.data.frame(x)
      eval_file <- na.omit(eval_file) 
      
      eval_file$x <- round(eval_file$x, digits = 5)
      eval_file$y <- round(eval_file$y, digits = 5)
      eval_file$ndvi <- round(eval_file$ndvi, digits = 5)
      eval_file$lst <- round(eval_file$lst, digits = 0)
      eval_file$elevation <- round(eval_file$elevation, digits = 0)
      eval_file$aspect <- round(eval_file$aspect, digits = 5)
      eval_file$slope <- round(eval_file$slope, digits = 5)
      eval_file$twi <- round(eval_file$twi, digits = 5)
      eval_file$bulk_density <- round(eval_file$bulk_density, digits = 0)
      
      eval_file <- data.frame(eval_file[,8:9], eval_file[,1:7])
      
      eval_file <- subset(eval_file, eval_file$ndvi != 0 & eval_file$lst != 0 & eval_file$elevation != 0 & eval_file$aspect != 0 & eval_file$slope != 0 & eval_file$twi != 0 & eval_file$bulk_density != 0)
      
      write.csv(eval_file, paste0("./4_Evaluation_data_csv/", year, "/", biweek, "/northamerica_eval_v71_250m_region_", 
                                  regions_list[j], "_", year, "_", biweek, ".csv"), row.names = FALSE)
      
      gc() 
      
      removeTmpFiles(h=0.01)
      
      print(regions_list[j])
      print(paste0("Biweek ", year, " ", biweek))
      print(head(eval_file))
      
    }
  }
}
