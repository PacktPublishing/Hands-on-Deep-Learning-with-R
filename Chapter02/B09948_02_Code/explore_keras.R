# load libraries
library(tensorflow)
library(keras)

# convert the prepared sample data (from prepare_sample_data.R) to matrices
train <- as.matrix(train)
test <- as.matrix(test)

# start a sequential model
model <- keras_model_sequential()

# set the number of units in the hidden layer and the activation function
model %>%
  layer_dense(units=35, activation = 'relu')

# set the evaluation metrics and correction mechanism
model %>% keras::compile(loss='binary_crossentropy',
                         optimizer='adam',
                         metrics='accuracy')

# fit a model
history <- model%>%
  fit(train, 
      train_target,
      epoch=10,
      batch=16,
      validation_split = 0.15)

# evaluate the model
model%>%
  keras::evaluate(test,test_target)