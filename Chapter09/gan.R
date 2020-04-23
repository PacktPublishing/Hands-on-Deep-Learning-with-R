freeze_weights(discriminator)

gan_in <- layer_input(shape = c(100))
gan_out <- discriminator(generator(gan_in))
gan <- keras_model(gan_in, gan_out)

gan_optimizer <- optimizer_adam(
  lr = 0.0004
)
gan %>% compile(
  optimizer = gan_optimizer,
  loss = "binary_crossentropy"
)

image_directory <- "gan_images"
dir.create(image_directory)

first_row <- 1

random_value_matrix <- matrix(rnorm(20 * 100),
                              nrow = 20, ncol = 100)

fake_images <- generator %>% predict(random_value_matrix)
fake_images[1,1:5,1:5,1]

last_row <- first_row + 19

real_images <- image_array[first_row:last_row,,,]

attr(real_images, "dimnames") <- NULL
attr(image_array, "dimnames") <- NULL

combined_images <- array(0, dim = c(nrow(real_images) * 2, 50,50,3))

combined_images[1:nrow(real_images),,,] <- fake_images
combined_images[(nrow(real_images)+1):(nrow(real_images)*2),,,] <- real_images

labels <- rbind(matrix(1, nrow = 20, ncol = 1),
                matrix(0, nrow = 20, ncol = 1))

labels <- labels + (0.1 * array(runif(prod(dim(labels))),
                                dim = dim(labels)))

d_loss <- discriminator %>% train_on_batch(combined_images, labels)

d_loss

random_value_matrix <- matrix(rnorm(20 * 100),
                              nrow = 20, ncol = 100)

fake_target_array <- array(0, dim = c(20, 1)) 

a_loss <- gan %>% train_on_batch(
  random_value_matrix,
  fake_target_array
)  

a_loss

first_row <- first_row + 20
if (first_row  > (nrow(image_array) - 20))
  first_row <- sample(1:10,1)

first_row

if (i %% 100 == 0) {
  
  cat("step:", i, "\n")
  cat("discriminator loss:", d_loss, "\n")
  cat("adversarial loss:", a_loss, "\n")  
  
  image_array_save(
    fake_images[1,,,] * 255,
    path = file.path(image_directory, paste0("fake_gwb", i, ".png"))
  )
  
  image_array_save(
    real_images[1,,,] * 255,
    path = file.path(image_directory, paste0("real_gwb", i, ".png"))
  )
}


for (i in 1:5000) {
  
  random_value_matrix <- matrix(rnorm(20 * 50), 
                                nrow = 20, ncol = 50)
  
  fake_images <- generator %>% predict(random_value_matrix)
  
  last_row <- first_row + 19
  
  real_images <- image_array[first_row:last_row,,,]
  
  combined_images <- array(0, dim = c(nrow(real_images) * 2, 50,50,3))
  
  combined_images[1:nrow(real_images),,,] <- fake_images
  combined_images[(nrow(real_images)+1):(nrow(real_images)*2),,,] <- real_images
  
  labels <- rbind(matrix(1, nrow = 20, ncol = 1),
                  matrix(0, nrow = 20, ncol = 1))
  
  labels <- labels + (0.1 * array(runif(prod(dim(labels))),
                                  dim = dim(labels)))
  
  d_loss <- discriminator %>% train_on_batch(combined_images, labels) 
  
  random_value_matrix <- matrix(rnorm(20 * 50), 
                                nrow = 20, ncol = 50)
  
  fake_target_array <- array(0, dim = c(20, 1))
  
  a_loss <- gan %>% train_on_batch( 
    random_value_matrix, 
    fake_target_array
  )  
  
  first_row <- first_row + 20
  if (first_row  > (nrow(image_array) - 20))
    first_row <- sample(1:10,1)
  
  if (i %% 100 == 0) { 
    
    cat("step:", i, "\n")
    cat("discriminator loss:", d_loss, "\n")
    cat("adversarial loss:", a_loss, "\n")  
    
    image_array_save(
      fake_images[1,,,] * 255, 
      path = file.path(image_directory, paste0("fake_gwb", i, ".png"))
    )
    
    image_array_save(
      real_images[1,,,] * 255, 
      path = file.path(image_directory, paste0("real_gwb", i, ".png"))
    )
  }
}

