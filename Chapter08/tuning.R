train_gen <- timeseries_generator(
  closing_deltas,
  closing_deltas,
  length = 10,
  sampling_rate = 1,
  stride = 1,
  start_index = 1,
  end_index = 1258,
  shuffle = FALSE,
  reverse = FALSE,
  batch_size = 1
)

test_gen <- timeseries_generator(
  closing_deltas,
  closing_deltas,
  length = 10,
  sampling_rate = 1,
  stride = 1,
  start_index = 1259,
  end_index = 1507,
  shuffle = FALSE,
  reverse = FALSE,
  batch_size = 1
)

model <- keras_model_sequential()

model %>%
  layer_lstm(units = 256,input_shape = c(10, 1),return_sequences="True") %>%
  layer_dropout(rate = 0.3) %>%
  layer_lstm(units = 256,input_shape = c(10, 1),return_sequences="False") %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 1, activation = "linear")

model %>%
  compile(
    optimizer = optimizer_adam(lr = 0.001), 
    loss = 'mse',
    metrics = 'accuracy')

model

history <- model %>% fit_generator(
  train_gen,
  epochs = 100,
  steps_per_epoch=1,
  verbose=2
)

evaluate_generator(model, train_gen, steps = 1200)
evaluate_generator(model, test_gen, steps = 200)