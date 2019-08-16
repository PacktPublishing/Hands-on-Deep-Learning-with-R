## add page numbers for bulleted objectives
## technical requirements, git URL and sub-headers
## add questions: 3 fact-based (definitions) / 3 application-based 
## further reading ...   ???
## format some terms with {;} to highlight code in text


library(tidyverse)
library(lubridate)
library(xgboost)
library(Metrics) 
library(DataExplorer)
library(caret)
la_no2 <- read_csv("data/LondonAir_TH_MER_NO2.csv")



utils::str(la_no2)


la_no2 %>% dplyr::group_by(Units, Site, Species) %>% dplyr::summarise(count = n())


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


DataExplorer::plot_missing(la_no2)
# image


DataExplorer::plot_bar(la_no2)
# image


la_no2 %>% dplyr::group_by(`Provisional or Ratified`) %>% dplyr::summarise(count = n())
# table

la_no2 <- la_no2 %>%
  dplyr::filter(
    `Provisional or Ratified` == 'R',
    !is.na(Value)
  )


la_no2 <- la_no2 %>%
  dplyr::select(-`Provisional or Ratified`)


range(la_no2$reading_year)
# output

la_no2 <- la_no2 %>%
  dplyr::select(-reading_year)


DataExplorer::plot_histogram(la_no2)



DataExplorer::plot_correlation(la_no2)


set.seed(1)
partition <- sample(nrow(la_no2), 0.75*nrow(la_no2), replace=FALSE)
train <- la_no2[partition,]
test <- la_no2[-partition,]

target <- train$Value

dtrain <- xgboost::xgb.DMatrix(data = as.matrix(train), label= target)
dtest <- xgboost::xgb.DMatrix(data = as.matrix(test))


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

xgb <- xgboost::xgb.train( 
  params = params, 
  data = dtrain,
  nrounds = 100
)


pred <- stats::predict(xgb, dtest)


Metrics::rmse(test$Value,pred) 
# [1] 0.05432884


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


xgb_grid <- expand.grid(
  nrounds = 500,
  eta = 0.01,
  max_depth = c(2,3,4),
  gamma = c(0,0.5,1),
  colsample_bytree = 0.75,
  min_child_weight = c(1,3,5),
  subsample = 0.8
)



xgb_tc = caret::trainControl(
  method = "cv",
  number = 5,
  search = "grid",
  returnResamp = "final",
  savePredictions = "final",
  verboseIter = TRUE,
  allowParallel = TRUE
)


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


xgb_param_tune$bestTune
# table results

# nrounds max_depth  eta gamma colsample_bytree min_child_weight subsample
# 19     100         4 0.01     0             0.75                1       0.8



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


xgb <- xgboost::xgb.train( 
  params = params, 
  data = dtrain,
  nrounds = 3162,
  print_every_n = 10,
  verbose = TRUE,
  maximize = FALSE
)


pred <- stats::predict(xgb, dtest)


Metrics::rmse(test$Value,pred) 
## [1] 0.02147039


