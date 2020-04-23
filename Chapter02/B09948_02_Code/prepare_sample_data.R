# load libraries
library(tidyverse)
library(caret)

# load adult data set training and test data 
# and add a column with labels to each
train <- read.csv("adult_processed_train.csv")
train <- train %>% dplyr::mutate(dataset = "train")
test <- read.csv("adult_processed_test.csv")
test <- test %>% dplyr::mutate(dataset = "test")

# bind data together
all <- rbind(train,test)

# keep only rows with no missing values
all <- all[complete.cases(all),]

# trim white space from factors
all <- all %>%
  mutate_if(~is.factor(.),~trimws(.))

# extract the training data
# create the target variable vector
# remove the target variable column and dataset label column
train <- all %>% filter(dataset == "train")
train_target <- as.numeric(factor(train$target))
train <- train %>% select(-target, -dataset)

# move all string variable to a subset
train_chars <- train %>%
  select_if(is.character)

# move all integers to a subset
train_ints <- train %>%
  select_if(is.integer)

# one-hot encode the string variables
ohe <- caret::dummyVars(" ~ .", data = train_chars)
train_ohe <- data.frame(predict(ohe, newdata = train_chars))

# bind integers and one-hot encoded variables
train <- cbind(train_ints,train_ohe)

# do all the same changes to the test data
test <- all %>% filter(dataset == "test")
test_target <- as.numeric(factor(test$target))
test <- test %>% select(-target, -dataset)

test_chars <- test %>%
  select_if(is.character)

test_ints <- test %>%
  select_if(is.integer)

ohe <- caret::dummyVars(" ~ .", data = test_chars)
test_ohe <- data.frame(predict(ohe, newdata = test_chars))

test <- cbind(test_ints,test_ohe)

# change target variables from 1 and 2 to 0 and 1
train_target <- train_target-1
test_target <- test_target-1

# remove one country that exists in the training data and not the test data
train <- train %>% select(-native.countryHoland.Netherlands)