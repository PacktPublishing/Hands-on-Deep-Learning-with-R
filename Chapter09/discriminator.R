discriminator_in <- layer_input(shape = c(50, 50, 3))  

discriminator_out <- discriminator_in %>%
  layer_conv_2d(filters = 256, kernel_size = 3) %>%
  layer_activation_leaky_relu() %>%
  layer_conv_2d(filters = 256, kernel_size = 5, strides = 2) %>%   
  layer_activation_leaky_relu() %>%
  layer_conv_2d(filters = 256, kernel_size = 5, strides = 2) %>%
  layer_activation_leaky_relu() %>%
  layer_conv_2d(filters = 256, kernel_size = 3, strides = 2) %>%
  layer_activation_leaky_relu() %>%
  layer_flatten() %>%
  layer_dropout(rate = 0.5) %>%     
  layer_dense(units = 1, activation = "sigmoid")

discriminator <- keras_model(discriminator_in, discriminator_out)
summary(discriminator)

discriminator_optimizer <- optimizer_adam(
  lr = 0.0008
)
discriminator %>% compile(
  optimizer = discriminator_optimizer,
  loss = "binary_crossentropy"
)