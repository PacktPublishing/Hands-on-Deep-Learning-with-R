# load library
library(keras)
library(caret)

# load data
fashion_mnist <- dataset_fashion_mnist()

# split data into training and test
train <- fashion_mnist$train$x
train_target <- fashion_mnist$train$y

test <- fashion_mnist$test$x
test_target <- fashion_mnist$test$y

# normalize all the values
train <- normalize(train)
test <- normalize(test)

# initialize the model as sequential
model <- keras_model_sequential()

# flatten the arrat of matrices to get all pixel values to a single row per image
model %>%
  layer_flatten(input_shape = c(28, 28))

# define the hidden layer 
# (here set with 256 units where the processed value from each is evaluated by the ReLU function)
model %>%
  layer_dense(units = 256, activation = 'relu') 

# set the output layer here with 10 units because the target variable has ten classes
model %>%
  layer_dense(units = 10, activation = 'softmax') 

# convert the target vectors to matrices
# this format is required for the model
test_target <- to_categorical(test_target)
train_target <- to_categorical(train_target)

# define the compile step
# this includes:
# how the error rate will be calculated (loss)
# how the model will make corrections based on the results of the loss function (optimizer)
# how the results will be evaluated (metrics)

model %>% compile(
  optimizer = 'adam',   
  loss = 'categorical_crossentropy', 
  metrics = 'categorical_accuracy'   
)

# fit the model
model %>% fit(train, train_target, epochs = 10)

# get performace value
score <- model %>% evaluate(test, test_target)
score$categorical_accuracy

# make predictions
preds <- model %>% predict(test)
predicted_classes <- model %>% predict_classes(test)

# evaluate performancd
test_target_vector <- fashion_mnist$test$y

caret::confusionMatrix(as.factor(predicted_classes),as.factor(test_target_vector))
                       
## Accuracy: 0.8876