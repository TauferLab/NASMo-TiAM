*The section numbers in this document match the numbers of the codes they describe within the preprocessing stage of the NASMo-TiAM 250m workflow.*

# 5 Validation
To test the outputs of the soil moisture values predicted with Random Forest, a cross-validation approach is taken, using the reference satellite-derived soil moisture data not used in the construction of the models.
## 5.1 Cross-Validation with Reference Satellite-Derived Soil Moisture Data
This code calculates correlation and root mean square error (RMSE) values based on matrices containing the predicted values and reference soil moisture (from ESA-CCI data). The input data for cross-validation corresponds with 30% of the sampling points set aside during the generation of the training matrices.
* The values of each predicted soil moisture pixel at 250 meters are compared with the reference values of satellite-derived soil moisture values at their original spatial resolution (0.25 degrees).
* The code produces a set of tables showing the observed and predicted values for each biweekly period.
* The code also creates a general table where all the correlation and RMSE values are reported along with the number of points used in each calculation.
## 5.2 Independent Validation with Ground-Truth Data
This code calculates correlation and root mean square error (RMSE) values based on matrices containing the predicted values and reference soil moisture records from the North American Soil Moisture Database (NASMD). To obtain reference correlation and RMSE values, the code also compares the input ESA-CCI soil moisture values with field records from NASMD.
* The values of each predicted soil moisture pixel at 250 meters are compared with available soil moisture field records from the NASMD across North America from 2002 to 2020.
* 864 NASMD stations are considered for this validation approach.
* The code produces a set of tables showing the observed and predicted values for each biweekly period.
* The code also creates a general table where all the correlation and RMSE values are reported along with the number of points used in each calculation.
