#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.4.3	Merge of Snow Cover weekly composites from MOD10A2 and MYD10A2 into biweekly combined layers

#This section merges the 8-days MOD10A2 and MYD10A2 Snow Cover composites into combined biweekly Snow Cover means.
#The values in the combined layers are reclassified to assign 0 to snow areas and 1 to the rest of the areas.
#The combined layers are thereafter masked to the North America region, reprojected, and resampled to WGS84, 
#setting the same coordinate reference system and cell size as the ESA-CCI preprocessed biweekly 
#means and the preprocessed terrain parameters.

##Libraries
library(raster)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = TRUE, timer = TRUE)

setwd("D:/3_North_America_SM_predictions")

##########

#Calculation of Snow Cover biweekly layers

MOD10A2_files <- list.files(path = "./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MOD10A2/2_8days_Mosaics_LAEA_250m",
                            pattern = ".tif", recursive = TRUE, full.names = TRUE)

MYD10A2_files <- list.files(path = "./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/MYD10A2/2_8days_Mosaics_LAEA_250m",
                            pattern = ".tif", recursive = TRUE, full.names = TRUE)

years <- c("2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010",
           "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")

biweeks <- c("01","02","03","04","05","06","07","08","09","10","11","12",
             "13","14","15","16","17","18","19","20","21","22","23")

weeks <- c("001_NorthAmerica","009_NorthAmerica","017_NorthAmerica","025_NorthAmerica","033_NorthAmerica","041_NorthAmerica",
           "049_NorthAmerica","057_NorthAmerica","065_NorthAmerica","073_NorthAmerica","081_NorthAmerica","089_NorthAmerica",
           "097_NorthAmerica","105_NorthAmerica","113_NorthAmerica","121_NorthAmerica","129_NorthAmerica","137_NorthAmerica",
           "145_NorthAmerica","153_NorthAmerica","161_NorthAmerica","169_NorthAmerica","177_NorthAmerica","185_NorthAmerica",
           "193_NorthAmerica","201_NorthAmerica","209_NorthAmerica","217_NorthAmerica","225_NorthAmerica","233_NorthAmerica",
           "241_NorthAmerica","249_NorthAmerica","257_NorthAmerica","265_NorthAmerica","273_NorthAmerica","281_NorthAmerica",
           "289_NorthAmerica","297_NorthAmerica","305_NorthAmerica","313_NorthAmerica","321_NorthAmerica","329_NorthAmerica",
           "337_NorthAmerica","345_NorthAmerica","353_NorthAmerica","361_NorthAmerica")

#Reclassification matrix
m <- c(-Inf, 199, 1,  200, 200, 0,  200, Inf, 1)
rclmat <- matrix(m, ncol=3, byrow=TRUE)

for (i in 1:length(years)) {
  for (j in seq(1,46,by=2)) {  

    MOD_snow_a <- MOD10A2_files[grep(paste0(years[i],weeks[j]), MOD10A2_files)]
    MOD_snow_b <- MOD10A2_files[grep(paste0(years[i],weeks[j+1]), MOD10A2_files)]
    MYD_snow_a <- MYD10A2_files[grep(paste0(years[i],weeks[j]), MYD10A2_files)]
    MYD_snow_b <- MYD10A2_files[grep(paste0(years[i],weeks[j+1]), MYD10A2_files)]

    MCD_snow_files <- c(MOD_snow_a,MOD_snow_b,MYD_snow_a,MYD_snow_b)

    if(length(MCD_snow_files) < 4) {
      
      print(paste0(years[i], " ", weeks[j], " No files"))
      
    } else {
    
      MOD_snow_a <- stack(MOD_snow_a)
      ext_mod_snow_a <- extent(MOD_snow_a)
      ext_mod_snow_a <- as.vector(ext_mod_snow_a)
      
      MOD_snow_b <- stack(MOD_snow_b)
      ext_mod_snow_b <- extent(MOD_snow_b)
      ext_mod_snow_b <- as.vector(ext_mod_snow_b)
      
      MYD_snow_a <- stack(MYD_snow_a)
      ext_myd_snow_a <- extent(MYD_snow_a)
      ext_myd_snow_a <- as.vector(ext_myd_snow_a)
      
      MYD_snow_b <- stack(MYD_snow_b)
      ext_myd_snow_b <- extent(MYD_snow_b)
      ext_myd_snow_b <- as.vector(ext_myd_snow_b)
   
      if((ext_mod_snow_a + ext_mod_snow_b) == (ext_myd_snow_a + ext_myd_snow_b)) {
    
        mean_snow <- stack(MOD_snow_a, MOD_snow_b, MYD_snow_a, MYD_snow_b)  
        
        mean_snow <- calc(mean_snow, mean, na.rm = TRUE)
        mean_snow <- reclassify(mean_snow, rclmat)
      
        mean_snow[mean_snow == 200] <- 0
     
        print(paste0(years[i], " ", weeks[j], " processing"))
        
        writeRaster(mean_snow, paste0("./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/NorthAmerica_biweekly_MCD10A2/1_LAEA/", 
                                     years[i], "/MCD10A2_NorthAmerica_061_snow_laea_mosaic_", years[i], "_biweek_", biweeks[(j+1)/2], "__.tif"), 
                    datatype='INT1U', overwrite = TRUE)  
        
        removeTmpFiles(h=0.01)
        
        print(paste0(years[i], " ", weeks[j], " finished"))
        
      } else {
        
        print("Different Extent")
      }
    }
  }
}


##########

##Masking of North America combined LST layers with North America Boundary.
#*This process works in R but takes a long time, so I performed this in ArcPro.

##LAEA##

reference_boundary <- shapefile("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/NA_LandCover_Boundary_2010_250m.shp")

snow_files <- list.files(path = "./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/NorthAmerica_biweekly_MCD10A2/1_LAEA",
                        pattern = ".tif", full.names = T, recursive = T)

for (i in 1:length(snow_files)) {
  
  temp_rast <- raster(snow_files[i])
  
  year <- substr(names(temp_rast), 43, 46)
  biweek <- substr(names(temp_rast), 55, 56)
  
  temp_rast <- crop(temp_rast, reference_boundary)
  temp_rast <- mask(temp_rast, reference_boundary)
  
  plot(temp_rast)
  
  writeRaster(temp_rast, paste0("./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/NorthAmerica_biweekly_MCD10A2/1_LAEA/", year,
                                "/MCD10A2_NorthAmerica_061_snow_laea_mosaic_", year, "_biweek_", i ,"_.tif"), overwrite = TRUE)
  
}

##Reprojection from LAEA to WGS84 and masking with the North American region boundary
#*This process works in R but takes a long time and does not accurately preserves pixels shape, so I performed this in Arc Pro.

##WGS84##

reference_raster <- raster("./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/3_RSAGA_NorthAmerica_terrain_parameters/2_WGS84/NorthAmerica_WGS84_250m_elevation.tif")

reference_boundary <- shapefile("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/00_northamerica_region_interest_wgs84.shp")

snow_files <- list.files(path = "./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/NorthAmerica_biweekly_MCD10A2/1_LAEA",
                        pattern = ".tif", full.names = T, recursive = T)

for (i in 1:length(snow_files)) {
  
  temp_rast <- raster(snow_files[i])
  
  year <- substr(names(temp_rast), 43, 46)
  biweek <- substr(names(temp_rast), 55, 56)
  
  temp_rast <- projectRaster(temp_rast, reference_raster)
  temp_rast <- mask(temp_rast, reference_boundary)
  
  plot(temp_rast)
  
  writeRaster(temp_rast, paste0("./1_Preprocessed_data/6_NorthAmerica_MODIS_SNOW/NorthAmerica_biweekly_MCD10A2/2_WGS84/", year,
                                "/MCD10A2_NorthAmerica_061_snow_wgs84_mosaic_", year, "_biweek_", i ,".tif"), overwrite = TRUE)
  
}

