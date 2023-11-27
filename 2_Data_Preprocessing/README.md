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

## 2.2 Terrain Parameters Calculation
### 2.2.1 Assembly of Digital Elevation Model (DEM) for North America
This part of the process imports the mean elevation layers from the GMTED2010 DEM tiles at 7.5 arc-second (WGS84), reprojects the tiles to Lambert Azimuthal Equal Area (LAEA) projection at 250 meters, and creates a mosaic cropped and masked to the North American region.
#### 2.2.1.1 DEM Tiles reprojection
Reprojection from WGS84 (geographic coordinates) to LAEA (metric coordinates).
* This step is necessary to calculate terrain parameters in RSAGA.
* The reference raster file in LAEA and 250 meters is the [Land Cover map of North America 2010](http://www.cec.org/north-american-environmental-atlas/land-cover-2010-modis-250m/), published by the Commission for Environmental Cooperation.
#### 2.2.1.2	DEM Tiles Mosaic
Mosaic of all reprojected tiles into a North American Mosaic.
* All tiles are in Lambert Azimuthal Area projection and 250 meters cell size.
#### 2.2.1.3	Masking to the region of interest
Masking of North American DEM mosaic.
* The output keeps data only within the North America boundary.
### 2.2.2	Calculation of Terrain Parameters
This part of the process calculates 15 terrain parameters using the “Basic Terrain Analysis” tool in the “TA compound analysis” of RSAGA.

Terrain parameters calculated.
1.	Analytical Hillshading
2.	Aspect
3.	Channel Network Base Level
4.	Vertical Distance to Channel Network
5.	Flow Accumulation
6.	Convergence Index
7.	Elevation
8.	Length-Slope Factor
9.	Longitudinal Curvature
10.	Cross Sectional Curvature
11.	Relative Slope Position
12.	Slope
13.	Topographic Wetness Index
14.	Catchment Area
15.	Valley Depth
-	The DEM must be in a projection based on metric units (e.g., LAEA).
-	Once the parameters are calculated, each raster output must be reprojected to WGS84 to be comparable with the ESA-CCI biweekly means created in script 2.1
-	This process takes about 4-5 days to finish in a computer with an Intel(R) Core(TM) i7-10700K CPU @ 3.80GHz 3.79 GHz processor, 16 cores and 64 GB of Installed RAM.
## 2.3	BULK DENSITY
This section takes all 0-5cm depth Bulk Density global tiles available in the Soil Grids system, creates a global mosaic, crops the data to the North America region, runs a reprojection and resample the data to the same coordinate reference system and cell size as the ESA-CCI preprocessed biweekly means and the preprocessed terrain parameters.
-	The global Bulk Density Mosaic is performed using the native SoilGrids Homolosine projection.
-	SoilGrids maps are delivered at a cell size of 250 meters.
-	Bulk density is expensed in cg/cm³.
-	Once the global mosaic is generated in Homolosine projection, it is cropped to the North America region, then reprojected and resampled using the WGS84 reference system and cell size of the preprocessed ESA-CCI biweekly means.


