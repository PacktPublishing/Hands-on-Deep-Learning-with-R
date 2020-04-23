## load libraries and data
library(tidyverse)
library(lubridate)
library(xgboost)
library(Metrics) 
library(DataExplorer)
library(caret)
la_no2 <- read_csv("data/LondonAir_TH_MER_NO2.csv")

## look at the columns
utils::str(la_no2)

## check that we are just looking at one type of pollution
la_no2 %>% dplyr::group_by(Units, Site, Species) %>% dplyr::summarise(count = n())

## remove Site, Species and Units because the all contain only one value
## convert Value to numeric and break out the date parts
## remove date columns after 
la_no2 <- la_no2 %>%
  dplyr::select(c(-Site,-Species,-Units)) %>%
  dplyr::mutate(
    Value = as.numeric(Value),
    reading_date = lubridate::dmy_hm(ReadingDateTime),
    reading_year = lubridate::year(reading_date),
    reading_month = lubridate::month(reading_date),
    reading_day = lubridate::day(reading_date),
    reading_hour = lubridate::hour(reading_date),
    reading_minute = lubridate::minute(reading_date)
  ) %>%
  dplyr::select(c(-ReadingDateTime, -reading_date)) 

## look at the proportion of missing values
DataExplorer::plot_missing(la_no2)

## look at the discrete variable distribution
DataExplorer::plot_bar(la_no2)

## look at a table of these discrete values
la_no2 %>% dplyr::group_by(`Provisional or Ratified`) %>% dplyr::summarise(count = n())

## remove provisional values because there are only four
la_no2 <- la_no2 %>%
  dplyr::filter(
    `Provisional or Ratified` == 'R',
    !is.na(Value)
  )

## remove the Provisional or Ratified column since it only contains one value now
la_no2 <- la_no2 %>%
  dplyr::select(-`Provisional or Ratified`)

## check how many years are included
range(la_no2$reading_year)

## remove the year column because it only contains one value
la_no2 <- la_no2 %>%
  dplyr::select(-reading_year)

## look at the continuous variables for outliers and skewness
DataExplorer::plot_histogram(la_no2)

## check varoable correlation
DataExplorer::plot_correlation(la_no2)

## set a seed for reproducibility 
set.seed(1)

## split the data into training and test data
partition <- sample(nrow(la_no2), 0.75*nrow(la_no2), replace=FALSE)
train <- la_no2[partition,]
test <- la_no2[-partition,]

## extract the target variable
target <- train$Value

## set up the train and test matrices for processing with xgboost
dtrain <- xgboost::xgb.DMatrix(data = as.matrix(train), label= target)
dtest <- xgboost::xgb.DMatrix(data = as.matrix(test))

## set the parameters for the model
params <-list(
  objective = "reg:linear",
  booster = "gbtree",
  eval_metric = "rmse",
  eta=0.1, 
  subsample=0.8,
  colsample_bytree=0.75,
  print_every_n = 10,
  verbose = TRUE
)

## fit the xgboost model
xgb <- xgboost::xgb.train( 
  params = params, 
  data = dtrain,
  nrounds = 100
)

## predict values using the model
pred <- stats::predict(xgb, dtest)

## evaluate results
Metrics::rmse(test$Value,pred) 
# [1] 0.05295431

## use 5-fold cross validation to discover the optimal number of rounds
xgb_cv <- xgboost::xgb.cv( 
  params = params, 
  data = dtrain, 
  nrounds = 10000, 
  nfold = 5, 
  showsd = T, 
  stratified = T,
  print_every_n = 100,
  early_stopping_rounds = 25, 
  maximize = F)

#Stopping. Best iteration:
# [3162]	train-rmse:0.000786+0.000029	test-rmse:0.010419+0.005467

## set up a grid for parameter tuning
xgb_grid <- expand.grid(
  nrounds = 500,
  eta = 0.01,
  max_depth = c(2,3,4),
  gamma = c(0,0.5,1),
  colsample_bytree = 0.75,
  min_child_weight = c(1,3,5),
  subsample = 0.8
)

## define how to use the grid to perform parameter tuning
xgb_tc = caret::trainControl(
  method = "cv",
  number = 5,
  search = "grid",
  returnResamp = "final",
  savePredictions = "final",
  verboseIter = TRUE,
  allowParallel = TRUE
)

## fit the model to tune the parameters
xgb_param_tune = caret::train(
  x = dtrain,
  y = target,
  trControl = xgb_tc,
  tuneGrid = xgb_grid,
  method = "xgbTree",
  verbose = TRUE
)

# Aggregating results
# Selecting tuning parameters
# Fitting nrounds = 100, max_depth = 4, eta = 0.01, gamma = 0, colsample_bytree = 0.75, min_child_weight = 1, subsample = 0.8 on full training set

## print the parameter values that are producing the best performing model to the console
xgb_param_tune$bestTune
# table results

# nrounds max_depth  eta gamma colsample_bytree min_child_weight subsample
# 19     100         4 0.01     0             0.75                1       0.8


## place these parameter values into the parameter list
params <-list(
  objective = "reg:linear",
  booster = "gbtree",
  eval_metric = "rmse",
  eta=0.01, 
  subsample=0.8,
  colsample_bytree=0.75,
  max_depth = 4,
  min_child_weight = 1,
  gamma = 1
)

## fit the model again
xgb <- xgboost::xgb.train( 
  params = params, 
  data = dtrain,
  nrounds = 3162,
  print_every_n = 10,
  verbose = TRUE,
  maximize = FALSE
)

## make a prediction using the model
pred <- stats::predict(xgb, dtest)

## evaluate the results (which have improved)
Metrics::rmse(test$Value,pred) 
## [1] 0.02147039


