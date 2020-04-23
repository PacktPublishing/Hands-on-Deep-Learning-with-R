# evaluate results
plot(history)


# caculate minimum and max rating
min_rating <- steamdata %>% summarise(min_rating = min(rating_scaled)) %>% pull()
max_rating <- steamdata %>% summarise(max_rating = max(rating_scaled)) %>% pull()

# create custom model with user, item, and bias embeddings
dot_with_bias <- function(
  embedding_dim,
  n_users,
  n_items,
  min_rating,
  max_rating,
  name = "dot_with_bias"
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
    self$user_bias <- layer_embedding(
      input_dim = n_users+1,
      output_dim = 1,
      name = "user_bias")
    self$item_bias <- layer_embedding(
      input_dim = n_items+1,
      output_dim = 1,
      name = "item_bias")
    
    
    self$user_dropout <- layer_dropout(
      rate = 0.3)
    self$item_dropout <- layer_dropout(
      rate = 0.5)
    self$dot <- layer_lambda(
      f = function(x)
        k_batch_dot(x[[1]],x[[2]],axes=2),
      name = "dot")
    self$dot_bias <- layer_lambda(
      f = function(x)
        k_sigmoid(x[[1]]+x[[2]]+x[[3]]),
      name = "dot_bias")
    self$min_rating <- min_rating
    self$max_rating <- max_rating
    self$pred <- layer_lambda(
      f = function(x)
        x * (self$max_rating - self$min_rating) + self$min_rating,
      name = "pred")
    function(x,mask=NULL,training=FALSE) {
      users <- x[,1]
      items <- x[,2]
      user_embedding <- self$user_embedding(users) %>% self$user_dropout()
      item_embedding <- self$item_embedding(items) %>% self$item_dropout()
      dot <- self$dot(list(user_embedding,item_embedding))
      dot_bias <- self$dot_bias(list(dot, self$user_bias(users), self$item_bias(items)))
      self$pred(dot_bias)
    }
  })
}


# define model 
model <- dot_with_bias(
  embedding_dim,
  n_users,
  n_items,
  min_rating,
  max_rating)

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
  batch_size = 50,
  validation_data = list(x_test,y_test),
  verbose = 1)
)


# summary model
summary(model)


# evaluate results
plot(history)