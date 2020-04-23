# load libraries
library(keras)
library(caret)

# load data and prepare if it is not already in your environment
fashion_mnist <- dataset_fashion_mnist()

# split data into training and test
train <- fashion_mnist$train$x
train_target <- fashion_mnist$train$y

test <- fashion_mnist$test$x
test_target <- fashion_mnist$test$y

# normalize all the values
train <- normalize(train)
test <- normalize(test)


# add all hidden layers and the output layer
# switching to leaky relu for the activation function
model <- keras_model_sequential()
model %>%
  layer_conv_2d(filters = 8, kernel_size = c(3,3), input_shape = c(28,28,1)) %>%
  layer_activation_leaky_relu() %>% 
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 16, kernel_size = c(3,3)) %>%
  layer_activation_leaky_relu() %>% 
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 32, kernel_size = c(3,3)) %>%
  layer_activation_leaky_relu() %>% 
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_flatten() %>%
  layer_dense(units = 128) %>%
  layer_activation_leaky_relu() %>% 
  layer_dense(units = 10, activation = 'softmax')

#  define the compile step
model %>% compile(
  loss = loss_categorical_crossentropy,
  optimizer = 'rmsprop',
  metrics = c('accuracy')
)

# fit the model
model %>% fit(
  train, train_target,
  batch_size = 100,
  epochs = 5,
  verbose = 1,
  validation_data = list(test, test_target)
)

# get the evaluation score
scores <- model %>% evaluate(
  test, test_target, verbose = 1
)

# make predictions
preds <- model %>% predict(test)
predicted_classes <- model %>% predict_classes(test)

# check performance
caret::confusionMatrix(as.factor(predicted_classes),as.factor(test_target_vector))