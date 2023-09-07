import numpy as np
import pandas as pd
import argparse
import pickle
from sklearn.ensemble import RandomForestRegressor
from sklearn.datasets import make_regression
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import RandomizedSearchCV
from sklearn.metrics import mean_squared_error


#Input arguments to execute the k-Nearest Neighbors Regression 
parser = argparse.ArgumentParser(description='Arguments and data files for executing Nearest Neighbors Regression.')
parser.add_argument('-t', "--trainingdata", help='Training data')
parser.add_argument('-m', "--pathtomodel", help='Directory where the knn model will be saved')
parser.add_argument('-maxtree', "--maxtree", help='Maximum number of trees to try for finding optimal model', default=2000)
parser.add_argument('-seed', "--seed", help='Seed for reproducibility purposed in random research grid', default=3)
args = parser.parse_args()

#Translate from namespaces to Python variables 
def from_args_to_vars (args):	
	print("Reading training data from", args.trainingdata)
	training_data = pd.read_csv(args.trainingdata)
	print(training_data)
	maxtree = int(args.maxtree)
	seed = int(args.seed)
	pathtomodel = args.pathtomodel
	return training_data, pathtomodel, maxtree, seed

def split_and_preprocess_trainingdata (training_data, pathtomodel):
	x_train, x_test, y_train, y_test = train_test_split(training_data.loc[:,training_data.columns != 'z'], training_data.loc[:,'z'], test_size=0.1)
	#print(x_train,"\n",y_train,"TEST\n",x_test,y_test)
	ss = StandardScaler()
	x_train = ss.fit_transform(x_train)
	x_test = ss.transform(x_test)
	#print("SCALED")
	#print(x_train,"\n",y_train,"TEST\n",x_test,y_test)
	
	# Save scaler model so it can be reused for predicting
	pickle.dump(ss, open(pathtomodel+'scaler_rf.pkl', 'wb'))
	return(x_train, y_train, x_test, y_test)

def random_parameter_search(rf, x_train, y_train, maxtree, seed):
        # Number of trees in random forest
        n_estimators = [int(x) for x in np.linspace(start = 300, stop = maxtree, num = 100)]
        # Number of features to consider at every split
        max_features = ['auto', 'sqrt']
        # Maximum number of levels in tree
        max_depth = [int(x) for x in np.linspace(10, 110, num = 11)]
        max_depth.append(None)
        # Minimum number of samples required to split a node
        min_samples_split = [2, 5, 10]
        # Minimum number of samples required at each leaf node
        min_samples_leaf = [1, 2, 4]
        # Method of selecting samples for training each tree
        bootstrap = [True, False]# Create the random grid
        params = {'n_estimators': n_estimators,
                       'max_features': ['sqrt'],
                       'max_depth': [20,50,70],
                       'bootstrap': [True],
                       'n_jobs':[-1]}
        # Random search based on the grid of params and n_iter controls number of random combinations it will try
        # n_jobs=-1 means using all processors
        # random_state sets the seed for manner of reproducibility 
        params_search = RandomizedSearchCV(rf, params, verbose=1, cv=10, n_iter=10, random_state=seed, n_jobs=-1)
        params_search.fit(x_train,y_train)
        # Check the results from the parameter search  
        print(params_search.best_score_)
        print(params_search.best_params_)
        print(params_search.best_estimator_)
        return params_search.best_estimator_


def train_rf(x_train, y_train, pathtomodel):
	# Define initial model
	rf = RandomForestRegressor()
	# Random parameter search for rf
	best_rf = random_parameter_search(rf, x_train, y_train, maxtree, seed)
	# Save model
	pickle.dump(best_rf, open(pathtomodel+'model_rf.pkl', 'wb'))
	
	return best_rf

def validate_rf(rf, x_test, y_test):
	# Predict on x_test
	y_test_predicted = rf.predict(x_test)
	# Measure the rmse
	rmse = np.sqrt(mean_squared_error(y_test, y_test_predicted))
	# Print error	
	#print("Predictions of soil moisture:", y_test_predicted)
	#print("Original values of soil moisture:", y_test)
	print("The rmse for the validation is:", rmse)


if __name__ == "__main__":	
	training_data, pathtomodel, maxtree, seed = from_args_to_vars(args)
	x_train, y_train, x_test, y_test = split_and_preprocess_trainingdata (training_data, pathtomodel)
	rf = train_rf(x_train, y_train, pathtomodel)
	validate_rf(rf, x_test, y_test)





