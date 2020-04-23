# load libraries
library(tidyverse)
library(caret)
library(randomForest)

# load data
fm <- readr::read_csv('fashionmnist/fashion-mnist_train.csv')
fm_test <- readr::read_csv('fashionmnist/fashion-mnist_test.csv')

# set seed for reproducability
set.seed(0)

# fit model
rf_model <- randomForest::randomForest(as.factor(label)~.,
                                       data = fm,
                                       ntree=10,
                                       mtry=5)

# make predictions
pred <- predict(rf_model, fm_test, type="response")

# evaluate performance
caret::confusionMatrix(as.factor(fm_test$label), pred)

# Accuracy : 0.8457