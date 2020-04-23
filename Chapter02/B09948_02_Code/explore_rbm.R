# load library
library(RBM)

# load FMNIST data
data(Fashion)

# create the train data set and train target vector
train <- Fashion$trainX
train_label <- Fashion$trainY

# fit the model
rbmModel <- RBM(x = t(train), y = train_label, n.iter = 500, n.hidden = 200, size.minibatch = 10)

# create the test data and test target vector
test <- Fashion$testX
test_label <- Fashion$testY

# predict using the model
PredictRBM(test = t(test), labels = test_label, model = rbmModel)