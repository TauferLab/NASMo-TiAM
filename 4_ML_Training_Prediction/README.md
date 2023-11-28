*The section numbers in this document match the numbers of the codes they describe within the preprocessing stage of the NASMo-TiAM 250m workflow.*

# 3 Generation of Biweekly Training and Prediction Matrices
This section generates training matrices based on 14 predefined subregions of interest for North America.
## 3.1 Training Matrices
### 3.1.1 Training matrices by predefined subregions
This code creates the training matrices for every biweekly period for 14 subregions of interest. The matrices depict the soil moisture values in the centroid coordinates of each coarse resolution ESA-CCI pixel, and the values of the 250 meters pixels spatially matching the same coordinates in the set of dynamic and static covariates.
* The use of subregions eases the process due to the large number of 250 meters pixels in all the covariates layers across North America.
* The code imports the ESA-CCI Soil Moisture reference data in coarse resolution (0.25 degrees), as well as the dynamic covariates (NDVI and LST), and the dynamic masks (Snow Cover) in fine resolution (250 meters) for ever biweekly period.
* The static covariates (terrain parameters and bulk density) are also imported.
* The set of imported layers are temporarily stored in a raster stack and then masked with the Snow Cover layer to remove snow and ice-covered areas from the output training matrices.
* The output training matrices are CSV files.
### 3.1.2	Union of subregions training matrices into North America matrices
This code takes the csv training matrices of the 14 subregions per biweekly period and aggregates them into North American training matrices.
### 3.1.3	North America biweekly training matrices split
This code randomly splits North America training files in 70% and 30 % for training the models and for later test.
## 3.2 Prediction Matrices
### 3.2.1	Prediction matrices by predefined subregions
This code creates the prediction matrices for every biweekly period for 44 subregions of interest. The matrices depict the values of the dynamic and static covariates for each biweekly period in the centroid coordinates of all 250 meters pixels within each subregion.
* The use of subregions eases the process due to the large number of 250 meters pixels in all the covariates layers across North America. 
* Different from the training matrices where the number of records was defined by the number of coarse resolution pixels (ESA-CCI data), prediction matrices hold all the points corresponding with the number of 250 pixels in each subregion, thus small subregions were defined for prediction matrices.
* The code imports the dynamic covariates (NDVI and LST), and the dynamic masks (Snow Cover) in fine resolution (250 meters) for ever biweekly period.
* The static covariates (terrain parameters and bulk density) are also imported.
* The set of imported layers are temporarily stored in a raster stack and then masked with the Snow Cover layer to remove snow and ice-covered areas from the output prediction matrices.
* The output prediction matrices are CSV files.

