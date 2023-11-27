*The section numbers in this document match the numbers of the codes they describe within the preprocessing stage of the NASMo-TiAM 250m workflow.*

# 2 Data Preprocessing
## 2.1 ESA CCI Soil Moisture Data
**Calculation of Biweekly means (16-days periods)**

This part of the process imports the ESA-CCI version 7.1 soil moisture estimates, crops, and masks the data to the North American region, then it calculates biweekly means and export them to TIFF format.
* Periods are defined based on the dates of MODIS products 16-days composites.
* Input ESA-CCI soil moisture .nc files are renamed to add the biweekly period that corresponds with the individual date of each file.
e.g. ESACCI-SOILMOISTURE-L3S-SSMV-COMBINED-20100626000000-fv07.1.nc  ->  ESACCI-SOILMOISTURE-L3S-SSMV-COMBINED-20100626000000-fv07.1_biweek_12.nc
* File Format = NC
* Input spatial resolution = 0.25 degrees
* Output spatial resolution = 0.25 degrees
* Input projection = WGS84
* Output projection = WGS84

