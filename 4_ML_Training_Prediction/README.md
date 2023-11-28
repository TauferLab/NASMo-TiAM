*The section numbers in this document match the numbers of the codes they describe within the preprocessing stage of the NASMo-TiAM 250m workflow.*

# 4 Prediction of Soil Moisture Biweekly Layers for North America
## 4.1 Models’ Generation and Soil Moisture Prediction
In this stage of the workflow, we use a traditional machine learning workflow, such as, random forest to predict the soil moisture values. Random forest operates by constructing a multitude of decision trees at training time and provides a prediction by applying the model to a new data point at inference time.
### 4.1.1 Random Forest Model Training
This code creates the ensemble of decision trees based on the training matrices. This code uses scikit-learn, which is a free software machine learning library for Python.

The inputs of this code are: 
* The training matrices generated in 3.1 Training matrices. The code takes the path to CSV formatted matrices. We are working on a new version of the code that takes TIF formatted matrices. 
* The maximum number of trees that are going to be considered for creating the model. 
* The seed for reproducibility purposes of random processed in the code.
* The path where the trained model is going to be stored. 

The code reads one training matrix at the time and standardizes [(StandardScaler)](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html) it by removing the mean and scaling to unit variance. The standardization method is also referred to the z-score. 

The code fits and transforms that training data and saves the scaler in pickle format (scaler.pkl) so it can be applied to the prediction matrices in the next stage. 

The code defines a [RandomForestRegressor](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestRegressor.html), and using cross validation does a random parameter search [(RandomizedSearchCV)](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.RandomizedSearchCV.html). In this step, the code decides the optimal number of decision trees, depth of the decision trees, the number of leaves for each node, and other parameters based on the best accuracy on the training matrices. 

The code saves the optimal parameters for the training data and model in a pickle format (model.pkl) so it can be applied for the predictions in the next stage. 

The outputs of the code are:
* The scaler for standardizing the data in the workflow scaler.pkl. 
* The trained random forest model model.pkl. 

### 4.1.2 Random Forest Soil Moisture Prediction
This code does the inference of random forest trained model to the prediction matrices to get the soil moisture predictions at a higher resolution.

The inputs of this code are:
* The prediction matrices generated in 3.2 Prediction Matrices. The code takes the path to CSV formatted matrices. We are working on a new version of the code that takes TIF formatted matrices. 
* The path to the scaler (scaler.pkl) so the prediction matrices are standardized with the same model as the training matrices.
* The path to the trained random forest model (model.pkl) so it can be applied on the prediction matrices.

The code reads the prediction matrices, loads the scaler.pkl and applies it to the matrices so they are standardized based on the training matrices.

The code loads the trained random forest model (model.pkl) and does inference on each point in the prediction matrices resulting on a soil moisture prediction. 

The output of this code is the predictions of soil moisture for the prediction matrices in CSV format.

## 4.2 Assemble of North America Soil Moisture Predictions Mosaics
### 4.2.1	Conversion of CSV predictions into raster files 
This code transforms the outputs of the Random Forest predictions from points to pixels in raster format. The code uses the preprocessed North America elevation raster file as reference and creates raster files in TIF format with the same coordinate reference system and pixel size as the reference.
* The outputs are up to 44 raster files per biweekly period, coinciding with the 44 predefined regions in the creation of the prediction matrices.
### 4.2.2	Mosaic of predicted North America Soil Moisture raster files
This section of the process takes all the raster files of the predicted soil moisture over the 44 subregions of interest and assembles a mosaic for North America.
