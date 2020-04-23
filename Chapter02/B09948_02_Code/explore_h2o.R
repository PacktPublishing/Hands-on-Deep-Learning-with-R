# load H2O package
library(h2o)

# start H2O
h2o::h2o.init()

# load data 
train <- read.csv("adult_processed_train.csv")
test <- read.csv("adult_processed_test.csv")

# load data on H2o
train <- as.h2o(train)
test <- as.h2o(test)

# pre-process by imputing missing values
h2o.impute(train, column = 0, method = c("mean", "median", "mode"))
h2o.impute(test, column = 0, method = c("mean", "median", "mode"))

# set dependent and independent variables
target <- "target"
predictors <- colnames(train)[1:14]

# train the model
model <- h2o.deeplearning(model_id = "h2o_dl_example"
                          ,training_frame = train
                          ,seed = 321
                          ,y = target
                          ,x = predictors
                          ,epochs = 10
                          ,nfolds = 5)

# evaluate model performance
h2o.performance(model, xval = TRUE)

# shutdown h2o
h2o::h2o.shutdown()