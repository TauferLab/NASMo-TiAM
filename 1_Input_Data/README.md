# 1 Input Data Collection
## 1.1 Soil Moisture Reference Data
[European Space Agency Climate Change Initiative (ESA CCI)](https://climate.esa.int/en/projects/soil-moisture/data/) soil moisture version 7.1
* Combined (active and passive) soil moisture daily estimates
* Spatial Resolution = 0.25 degrees
* File Format = NC
* Projection = WGS84
* Time frame = June 26, 2002, to December 31, 2020 (6,764 daily estimates)
## 1.2 Prediction Covariates
### 1.2.1 Static Covariates
#### 1.2.1.1 Elevation Data
[Global Multi-resolution Terrain Elevation Data (GMTED2010)](https://www.usgs.gov/centers/eros/science/usgs-eros-archive-digital-elevation-global-multi-resolution-terrain-elevation#overview)
* 19 tiles of mean elevation (the tiles folders contain other elevation values such as maximum elevation, minimum, median, standard deviation) covering North America
* Spatial Resolution = 7.5 arc-second
* File Format = TIF
* Projection = WGS84
* Units (elevation) = meters
#### 1.2.1.2 Bulk Density Data
[Soil Grids global Bulk Density](https://www.isric.org/explore/soilgrids)
* 1,128 tiles for global cover
* 0-5 cm bulk density modeled values
* Spatial Resolution = 250 m
* File Format = TIF
* Projection = Homolosine
* Units = cg/cm3
### 1.2.2 Dynamic Covariates
#### 1.2.2.1 Normalized Difference Vegetation Index (NDVI)
[MOD13Q1 (Modis Terra NDVI)](https://lpdaac.usgs.gov/products/mod13q1v006/)
* Repository = NASA EARTH Data Search
* Data available since 2000
* 23 16-days composites per year (starting on January 1st)
* Up to 52 Tiles covering the North American region. Not all the tiles have data for every 16-days composites, data are scarce in arctic regions during winter periods.
* 20,999 files collected from 2000 to 2020
* Tile dimensions = 1,200 x 1,200 km
* Version = 6.1
* Spatial Resolution = 250 m
* File Format = HDF (Hierarchical Data Format)
* Projection = Sinusoidal
[MYD13Q1 (Modis Aqua NDVI)](https://lpdaac.usgs.gov/products/myd13q1v006/)
* Repository = NASA EARTH Data Search
* Data available since mid-2002
* 23 16-days composites per year (starting on January 9th)
* Up to 52 Tiles covering the North American region. Not all the tiles have data for every 16-days composites, data are scarce in arctic regions during winter periods.
* 19,431 files collected from 2002 to 2020
* Tile dimensions = 1,200 x 1,200 km
* Version = 6.1
* Spatial Resolution = 250 m
* File Format = HDF (Hierarchical Data Format)
* Projection = Sinusoidal
#### 1.2.2.2 Land Surface Temperature (LST)
[MOD11A2 (Modis Terra LST)](https://lpdaac.usgs.gov/products/mod11a2v006/)
* Repository = NASA EARTH Data Search
* Data available since 2000
* 46 8-days composites per year (starting on January 1st)
* Up to 52 Tiles covering the North American region. Not all the tiles have data for every 8-days composites, data are scarce in arctic regions during winter periods.
* 43,123 files collected from 2000 to 2020
* Tile dimensions = 1,200 x 1,200 km
* Version = 6.1
* Spatial Resolution = 1,000 m
* File Format = HDF (Hierarchical Data Format)
* Projection = Sinusoidal
[MYD11A2 (Modis Aqua LST)](https://lpdaac.usgs.gov/products/myd11a2v006/)
* Repository = NASA EARTH Data Search
* Data available since mid-2002
* 46 8-days composites per year (starting on January 1st)
* Up to 52 Tiles covering the North American region. Not all the tiles have data for every 8-days composites, data are scarce in arctic regions during winter periods.
* 38,295 files collected from 2002 to 2020
* Tile dimensions = 1,200 x 1,200 km
* Version = 6.1
* Spatial Resolution = 1,000 m
* File Format = HDF (Hierarchical Data Format)
* Projection = Sinusoidal
### 1.2.3 Dynamic Masks
#### 1.2.3.1 Snow Cover Extent
[MOD10A2 (Modis Terra Snow Cover)](https://nsidc.org/data/mod10a2/versions/61)
* Repository = NASA EARTH Data Search
* Data available since 2000
* 46 8-days composites per year (starting on January 1st)
* Up to 52 Tiles covering the North American region. Not all the tiles have data for every 8-days composites, data are scarce in arctic regions during winter periods.
* 42,095 files collected from 2000 to 2020
* Tile dimensions = 10 x 10 degrees
* Version = 6.1
* Spatial Resolution = 500 m
* File Format = HDF (Hierarchical Data Format)
* Projection = Sinusoidal
[MYD10A2 (Modis Aqua Snow Cover)](https://nsidc.org/data/myd10a2/versions/61)
* Repository = NASA EARTH Data Search
* Data available since mid-2002
* 46 8-days composites per year (starting on January 1st)
* Up to 52 Tiles covering the North American region. Not all the tiles have data for every 8-days composites, data are scarce in arctic regions during winter periods.
* 37,413 files collected from 2002 to 2020
* Tile dimensions = 10 x 10 degrees
* Version = 6.1
* Spatial Resolution = 500 m
* File Format = HDF (Hierarchical Data Format)
* Projection = Sinusoidal
