# load libraries
library(tidyverse)
library(caret)
library(neuralnet)
library(Metrics)

# subset the data to set up a binary classification problem
fm <- fm %>% dplyr::filter(label < 2)
fm_test <- fm_test %>% dplyr::filter(label < 2)


# get the data arguemengt in the proper syntax
n <- names(fm)
formula <- as.formula(paste("label ~", paste(n[!n == "label"], collapse = " + ", sep = "")))

# train our model
net <- neuralnet::neuralnet(formula,
                            data = fm,
                            hidden = 250,
                            linear.output = FALSE,
                            act.fct = "logistic"
)

# make predictions
prediction_list <- neuralnet::compute(net, fm_test)
predictions <- as.vector(prediction_list$net.result)

# check the AUC score
Metrics::auc(test_label, predictions)

# 0.97487