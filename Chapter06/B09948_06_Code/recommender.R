# create custom model with user and item embeddings
dot <- function(
  embedding_dim,
  n_users,
  n_items,
  name = "dot"
) {
  keras_model_custom(name = name, function(self) {
    self$user_embedding <- layer_embedding(
      input_dim = n_users+1,
      output_dim = embedding_dim,
      name = "user_embedding")
    self$item_embedding <- layer_embedding(
      input_dim = n_items+1,
      output_dim = embedding_dim,
      name = "item_embedding")
    self$dot <- layer_lambda(
      f = function(x)
        k_batch_dot(x[[1]],x[[2]],axes=2),
      name = "dot"
    )
    function(x, mask=NULL, training=FALSE) {
      users <- x[,1]
      items <- x[,2]
      user_embedding <- self$user_embedding(users) 
      item_embedding <- self$item_embedding(items) 
      dot <- self$dot(list(user_embedding, item_embedding))
    }
  })
}


# initialize embedding parameter
embedding_dim <- 50

# define model 
model <- dot(
  embedding_dim,
  n_users,
  n_items
)


# compile model 
model %>% compile(
  loss = "mse",
  optimizer = "adam"
)


# train model 
history <- model %>% fit(
  x_train,
  y_train,
  epochs = 10,
  batch_size = 500,
  validation_data = list(x_test,y_test),
  verbose = 1
)


summary(model)