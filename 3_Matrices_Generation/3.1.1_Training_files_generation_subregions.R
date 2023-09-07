#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #3. Generation of Biweekly Training and Prediction matrices

###3.1.1 Generation of North America training matrices by predefined sub-regions

#This code creates the training matrices for every biweekly period for 14 sub-regions of interest. 
#The matrices depict the soil moisture values in the centroid coordinates of each coarse resolution 
#ESA-CCI pixel, and the values of the 250 meters pixels spatially matching the same coordinates 
#in the set of dynamic and static covariates.

#The code imports the ESA-CCI Soil Moisture reference data in coarse resolution (0.25 degrees), 
#as well as the dynamic covariates (NDVI and LST), and the dynamic masks (Snow Cover) in fine 
#resolution (250 meters) for ever biweekly period. The set of imported layers are 
#temporarily stored in a raster stack and then masked with the Snow Cover layer to remove snow 
#and ice-covered areas from the output training matrices.

##Libraries
library(raster)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("D:/3_North_America_SM_predictions")

##########

biweeks <- c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23")

regions_list <- c("01","02","03","04","05","06","07","08","09","10","11","12","13","14")

regions_sections <- as.list(c("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_01.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_02.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_03.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_04.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_05.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_06.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_07.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_08.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_09.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_10.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_11.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_12.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_13.shp",
                              "./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/northamerica_train_fishnet/northamerica_train_fishnet_wgs84_14.shp"))

#Import of static covariates (elevation, aspect, slope, twi, bulk density)

esa_cci_northamerica_files <- list.files(path = "./2_Covariates/0_esacci_soil_moisture", pattern = "tif", recursive = TRUE, full.names = TRUE)
esa_cci_northamerica_files <- as.list(esa_cci_northamerica_files)

static_covariates <- list.files(path = "./2_Covariates/1_static_covariates", pattern = "tif", recursive = TRUE, full.names = TRUE)
static_covariates <- as.list(static_covariates[1:16])
static_covariates <- static_covariates[c(7,2,12,14,13)]

lst_northamerica_files <- list.files(path = "./2_Covariates/2_dinamyc_covariates/LST", pattern = "tif", recursive = TRUE, full.names = TRUE)
lst_northamerica_files <- as.list(lst_northamerica_files)

ndvi_northamerica_files <- list.files(path = "./2_Covariates/2_dinamyc_covariates/NDVI", pattern = "tif", recursive = TRUE, full.names = TRUE)
ndvi_northamerica_files <- as.list(ndvi_northamerica_files)

snow_masks_northamerica_files <- list.files(path = "./2_Covariates/3_masks/SNOW", pattern = "tif", recursive = TRUE, full.names = TRUE)
snow_masks_northamerica_files <- as.list(snow_masks_northamerica_files)

#####

elevation <- raster(static_covariates[[1]])
aspect <- raster(static_covariates[[2]])
slope <- raster(static_covariates[[3]])
twi <- raster(static_covariates[[4]])
bulkdensity <- raster(static_covariates[[5]])
static_covariates <- stack(elevation, aspect, slope, twi, bulkdensity)


for (j in 1:length(regions_list)) {
  
  temp_boundary <- shapefile(regions_sections[[j]])
  
  for (i in 1:length(esa_cci_northamerica_files)) {
    
    base_table <- matrix(data = NA, nrow = 0, ncol = 10)
    base_table <- as.data.frame(base_table)
    names(base_table) <- c("x","y","z","ndvi","lst","elevation","aspect","slope","twi","bulk_density")
    
    #load biweekly ESA-CCI soil moisture layer 
    r <- raster(esa_cci_northamerica_files[[i]])
    year <- substr(names(r), 24, 27)
    biweek_no <- substr(names(r), 36, 37)
    #define lat long projection
    proj4string(r) <- CRS("+proj=longlat +datum=WGS84 +no_defs")
    #convert to spatial pixels data frame
    r <- as(r,'SpatialPixelsDataFrame')
    #convert to data frame
    df=as.data.frame(r, xy=T)
    #remove no data values
    df=na.omit(df)
    #define column coordinates 
    coordinates(df)=~x+y
    #and lat long projection system
    proj4string(df) <- CRS("+proj=longlat +datum=WGS84 +no_defs")
    
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
    
    #convert to spatial pixels data frame
    x<- as(x,'SpatialPixelsDataFrame')
    
    #overlay soil moisture centroids and prediction covariates (x)
    ov=over(df, x)
    #generate a data frame
    d=as.data.frame(df)
    #combine extracted values
    y=cbind(d,  ov)
    #remove no data values
    y=na.omit(y)
    #training set year i
    z=data.frame(y[,2:3], z=y[,1],  y[,4:10])
    
    names(z) <- c("x","y","z","ndvi","lst","elevation","aspect","slope","twi","bulk_density")
    
    base_table <- rbind(base_table, z)
    base_table$x <- round(base_table$x, digits = 5)
    base_table$y <- round(base_table$y, digits = 5)
    base_table$z <- round(base_table$z, digits = 5)
    base_table$ndvi <- round(base_table$ndvi, digits = 5)
    base_table$lst <- round(base_table$lst, digits = 0)
    base_table$elevation <- round(base_table$elevation, digits = 0)
    base_table$aspect <- round(base_table$aspect, digits = 5)
    base_table$slope <- round(base_table$slope, digits = 5)
    base_table$twi <- round(base_table$twi, digits = 5)
    base_table$bulk_density <- round(base_table$bulk_density, digits = 0)
    
    base_table <- subset(base_table, base_table$ndvi != 0 & base_table$lst != 0 & base_table$elevation != 0 & base_table$aspect != 0 & base_table$slope != 0 & base_table$twi != 0 & base_table$bulk_density != 0)
    
    write.csv(base_table, paste0("./3_Training_and_Test_data_csv/0_regions/region_", regions_list[j], "/Train_matrix_region_", 
                                 regions_list[j], "_v71_250m_", year, "_",biweek_no, ".csv"), row.names = FALSE)
    
    gc() 
    
    removeTmpFiles(h=0.01)
    
    print(paste0("region  ", regions_list[j]))
    print(paste0(year, "  ", biweek_no))
    print(head(base_table))
    
  }
  
}
