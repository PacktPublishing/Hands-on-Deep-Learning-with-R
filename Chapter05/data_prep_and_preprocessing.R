library(mxnet) 
library(tidyverse) 
library(caret)

train <- read.csv("adult_processed_train.csv") 
train <- train %>% mutate(dataset = "train") 
test <- read.csv("adult_processed_test.csv") 
test <- test %>% mutate(dataset = "test")

all <- rbind(train,test)
all <- all[complete.cases(all),] 

unique(all$sex)
all <- all %>%  mutate_if(~is.factor(.),~trimws(.)) 

train <- all %>% filter(dataset == "train") 
train_target <- as.numeric(factor(train$target)) 
train <- train %>% select(-target, -dataset)

train_chars <- train %>%  
  select_if(is.character)

train_ints <- train %>% 
  select_if(is.integer)

ohe <- caret::dummyVars(" ~ .", data = train_chars) 
train_ohe <- data.frame(predict(ohe, newdata = train_chars))

train <- cbind(train_ints,train_ohe)

train <- train %>% mutate_all(funs(scales::rescale(.) %>% as.vector))

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
test <- test %>% mutate_all(funs(scales::rescale(.) %>% as.vector)) 

setdiff(names(train), names(test))
train <- train %>% select(-native.countryHoland.Netherlands)

train_target <- train_target-1 
test_target <- test_target-1 
