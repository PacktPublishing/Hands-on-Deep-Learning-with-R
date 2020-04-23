library(keras)
generator_in <- layer_input(shape = c(100))  

generator_out <- generator_in %>%
  layer_dense(units = 128 * 25 * 25) %>%
  layer_batch_normalization(momentum = 0.5) %>%
  layer_activation_relu() %>%
  layer_reshape(target_shape = c(25, 25, 128)) %>%
  layer_conv_2d(filters = 512, kernel_size = 5,
                padding = "same") %>%
  layer_batch_normalization(momentum = 0.5) %>%
  layer_activation_relu() %>%
  layer_conv_2d_transpose(filters = 256, kernel_size = 4,
                          strides = 2, padding = "same") %>%
  layer_batch_normalization(momentum = 0.5) %>%
  layer_activation_relu() %>%
  layer_conv_2d(filters = 256, kernel_size = 5,
                padding = "same") %>%
  layer_batch_normalization(momentum = 0.5) %>%
  layer_activation_relu() %>%
  layer_conv_2d(filters = 128, kernel_size = 5,
                padding = "same") %>%
  layer_batch_normalization(momentum = 0.5) %>%
  layer_activation_relu() %>%
  layer_conv_2d(filters = 64, kernel_size = 5,
                padding = "same") %>%
  layer_batch_normalization(momentum = 0.5) %>%
  layer_activation_relu() %>%
  layer_conv_2d(filters = 3, kernel_size = 7,
                activation = "tanh", padding = "same")

generator <- keras_model(generator_in, generator_out)
summary(generator)