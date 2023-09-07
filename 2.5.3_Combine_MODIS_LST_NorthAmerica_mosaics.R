#NORTH AMERICA SOIL MOISTURE DATASET DERIVED FROM TIME-SPECIFIC ADAPTABLE MODELS

  #2. Data Preprocessing

###2.4.3	Merge of LST weekly composites from MOD11A2 and MYD11A2 into biweekly combined layers

#This section merges the 8-days MOD11A2 and MYD11A2 LST composites into combined biweekly LST means. 
#The combined layers are thereafter masked to the North America region, reprojected, and resampled to WGS84, 
#setting the same coordinate reference system and cell size as the ESA-CCI preprocessed biweekly 
#means and the preprocessed terrain parameters.

##Libraries
library(raster)
##########

rasterOptions(tmpdir = "E:/R_tempdirs/", progress = "text", timer = TRUE)

setwd("D:/3_North_America_SM_predictions")

##########

#Calculation of LST biweekly layers

MOD11A2_files <- list.files(path = "./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MOD11A2/2_8days_Mosaics_LAEA_250m",
                            pattern = ".tif", recursive = TRUE, full.names = TRUE)

MYD11A2_files <- list.files(path = "./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/MYD11A2/2_8days_Mosaics_LAEA_250m",
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

for (i in 1:length(years)) {
  for (j in seq(1,46,by=2)) {  
    
    MOD_lst_a <- MOD11A2_files[grep(paste0(years[i],weeks[j]), MOD11A2_files)]
    MOD_lst_b <- MOD11A2_files[grep(paste0(years[i],weeks[j+1]), MOD11A2_files)]
    MYD_lst_a <- MYD11A2_files[grep(paste0(years[i],weeks[j]), MYD11A2_files)]
    MYD_lst_b <- MYD11A2_files[grep(paste0(years[i],weeks[j+1]), MYD11A2_files)]
    
    MCD_lst_files <- c(MOD_lst_a,MOD_lst_b,MYD_lst_a,MYD_lst_b)
    
    if(length(MCD_lst_files) < 4) {
      
      print(paste0(years[i], " ", weeks[j], " No files"))
      
    } else {
      
      MOD_lst_a <- stack(MOD_lst_a)
      ext_mod_lst_a <- extent(MOD_lst_a)
      ext_mod_lst_a <- as.vector(ext_mod_lst_a)
      
      MOD_lst_b <- stack(MOD_lst_b)
      ext_mod_lst_b <- extent(MOD_lst_b)
      ext_mod_lst_b <- as.vector(ext_mod_lst_b)
      
      MYD_lst_a <- stack(MYD_lst_a)
      ext_myd_lst_a <- extent(MYD_lst_a)
      ext_myd_lst_a <- as.vector(ext_myd_lst_a)
      
      MYD_lst_b <- stack(MYD_lst_b)
      ext_myd_lst_b <- extent(MYD_lst_b)
      ext_myd_lst_b <- as.vector(ext_myd_lst_b)
      
      
      if((ext_mod_lst_a + ext_mod_lst_b) == (ext_myd_lst_a + ext_myd_lst_b)) {
        
        mean_lst <- stack(MOD_lst_a, MOD_lst_b, MYD_lst_a, MYD_lst_b)  
        
        print(paste0(years[i], " ", weeks[j], " processing"))
        
        mean_lst <- calc(mean_lst, mean, na.rm = TRUE)
        
        writeRaster(mean_lst, paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/NorthAmerica_biweekly_MCD11A2/1_LAEA/", 
                                      years[i], "/MCD11A2_NorthAmerica_061_lst_laea_mosaic_", years[i], "_biweek_", biweeks[(j+1)/2], "__.tif"), 
                                      overwrite = TRUE)  
        
        removeTmpFiles(h=0.01)
        
        print(paste0(years[i], " ", weeks[j], " finished"))
        
      }
    }
  }
}


##########

##Masking of North America combined LST layers with North America Boundary.
#*This process works in R but takes a long time, so I performed this in ArcPro.

##LAEA##

reference_boundary <- shapefile("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/NA_LandCover_Boundary_2010_250m.shp")

lst_files <- list.files(path = "./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/NorthAmerica_biweekly_MCD11A2/1_LAEA",
                         pattern = ".tif", full.names = T, recursive = T)

for (i in 1:length(lst_files)) {
  
  temp_rast <- raster(lst_files[i])
  
  year <- substr(names(temp_rast), 42, 45)
  biweek <- substr(names(temp_rast), 54, 55)
  
  temp_rast <- crop(temp_rast, reference_boundary)
  temp_rast <- mask(temp_rast, reference_boundary)
  
  plot(temp_rast)
  
  writeRaster(temp_rast, paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/NorthAmerica_biweekly_MCD11A2/1_LAEA/", year,
                                "/MCD11A2_NorthAmerica_061_lst_laea_mosaic_", year, "_biweek_", i ,"_.tif"), overwrite = TRUE)
  
}

##Reprojection from LAEA to WGS84 and masking with the North American region boundary
#*This process works in R but takes a long time and does not accurately preserves pixels shape, so I performed this in Arc Pro.

##WGS84##

reference_raster <- raster("./1_Preprocessed_data/2_NA_GMTED2010_terrain_parameters/3_RSAGA_NorthAmerica_terrain_parameters/2_WGS84/NorthAmerica_WGS84_250m_elevation.tif")

reference_boundary <- shapefile("./0_Input_data/0_NorthAmerica_boundary_and_reference_raster/00_northamerica_region_interest_wgs84.shp")

lst_files <- list.files(path = "./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/NorthAmerica_biweekly_MCD11A2/1_LAEA",
                         pattern = ".tif", full.names = T, recursive = T)

for (i in 1:length(lst_files)) {
  
  temp_rast <- raster(lst_files[i])
  
  year <- substr(names(temp_rast), 42, 45)
  biweek <- substr(names(temp_rast), 54, 55)
  
  temp_rast <- projectRaster(temp_rast, reference_raster)
  temp_rast <- mask(temp_rast, reference_boundary)
  
  plot(temp_rast)
  
  writeRaster(temp_rast, paste0("./1_Preprocessed_data/5_NorthAmerica_MODIS_LST/NorthAmerica_biweekly_MCD11A2/2_WGS84/", year,
                                "/MCD11A2_NorthAmerica_061_lst_wgs84_mosaic_", year, "_biweek_", i ,".tif"), overwrite = TRUE)
  
}

