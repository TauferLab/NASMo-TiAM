# NASMo-TiAM 250m
Workflow for Generating North America Soil Moisture at 250m Dataset Derived from Time-specific Adaptable Machine Learning Models.

NASMo-TiAM 250m workflow is based on standardized input data, where all the prediction covariates are preprocessed to allocate the same temporal and spatial characteristics.

The current version of NASMo-TiAM uses Random Forest to perform surface Soil Moisture (0-5cm depth) predictions at 250m of spatial resolution on 16-day periods from mid-2002 to
December 2020 over North America.

The scripts contained in this workflow are the base for:
- Data Preprocessing
- Generation of Time-Specific Training and Prediction Matrices
- Prediction of Soil Moisture Time-Specific layers for North America
- Validation
