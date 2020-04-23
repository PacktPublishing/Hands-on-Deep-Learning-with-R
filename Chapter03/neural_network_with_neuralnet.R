# load libraries
library(tidyverse)
library(caret) 
library(Metrics)

# load data
wbdc <- readr::read_csv("http://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data", col_names = FALSE)

# convert the target variable to 1 and 0 and relabel
wbdc <- wbdc %>%
  dplyr::mutate(target = dplyr::if_else(X2 == "M", 1, 0)) %>%
  dplyr::select(-X2)

# scale and standarize all independent variables
wbdc <- wbdc %>% dplyr::mutate_at(vars(-X1, -target), funs((. - min(.))/(max(.) - min(.)) ))

# create a training and test data set by performing an 80/20 split
train <- wbdc %>% dplyr::sample_frac(.8)
test  <- dplyr::anti_join(wbdc, train, by = 'X1')

# remove the ID column
test <- test %>% dplyr::select(-X1)
train <- train  %>% dplyr::select(-X1)

# extract the target variables into a separate vector and remove from the test data
actual <- test$target
test <- test %>% dplyr::select(-target)

# prepare the data argument for the neuralnet function by getting it into the syntax required
n <- names(train)
formula <- as.formula(paste("target ~", paste(n[!n == "target"], collapse = " + ", sep = "")))

# train a neural net on the data
net <- neuralnet::neuralnet(formula,
                            data = train,
                            hidden = c(15,15),
                            linear.output = FALSE,
                            act.fct = "logistic"
)


# make prediction using the model
prediction_list <- neuralnet::compute(net, test)

# convert the predictions to binary values for evaluation
predictions <- as.vector(prediction_list$net.result)
binary_predictions <- dplyr::if_else(predictions > 0.5, 1, 0)

# calculate the percentage of correct predictions
sum(binary_predictions == actual)/length(actual)

# evaluate the results using a confusion matrix
results_table <- table(binary_predictions, actual)
caret::confusionMatrix(results_table)

# evaluate the resulyts using the AUC score
Metrics::auc(actual, predictions)


# add a backpropagation step
bp_net <- neuralnet::neuralnet(formula,
                               data = train,
                               hidden = c(15,15),
                               linear.output = FALSE,
                               act.fct = "logistic",
                               algorithm = "backprop",
                               learningrate = 0.00001,
                               threshold = 0.3,
                               stepmax = 1e6
)


# check accuracy again
prediction_list <- neuralnet::compute(bp_net, test)
predictions <- as.vector(prediction_list$net.result)
binary_predictions <- dplyr::if_else(predictions > 0.5, 1, 0)

results_table <- table(binary_predictions, actual)

Metrics::auc(actual, predictions)
caret::confusionMatrix(results_table)