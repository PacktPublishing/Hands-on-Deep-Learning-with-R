library(R6)
library(keras)
library(dequer)
library(gym)
library(reinforcelearn)

DQNAgent <- R6Class("DQNAgent",
                    portable = FALSE,
                    lock_objects = FALSE,
                    public = list(
                      state_size = NULL,
                      action_size = NA, 
                      initialize = function(state_size, action_size) {
                        self$state_size = state_size
                        self$action_size = action_size
                        self$memory = deque()
                        self$gamma = 0.95 # discount rate
                        self$epsilon = 1.0 # exploration rate
                        self$epsilon_min = 0.01
                        self$epsilon_decay = 0.995
                        self$learning_rate = 0.001
                        self$model = self$build_model()
                      },
                      build_model = function(...){
                        ## Creating the sequential model
                        model = keras_model_sequential() %>% 
                          layer_dense(units = 24, activation = "relu", input_shape = self$state_size) %>%
                          layer_dense(units = 24, activation = "relu") %>%
                          layer_dense(units = self$action_size, activation = "linear")
                        
                        compile(model, loss = "mse", optimizer = optimizer_adam(lr = self$learning_rate), metrics = "accuracy")
                        
                        return(model)
                      },
                      memorize = function(state, action, reward, next_state, done){
                        pushback(self$memory,state)
                        pushback(self$memory,action)
                        pushback(self$memory,reward)
                        pushback(self$memory, next_state)
                        pushback(self$memory, done)
                      },
                      act = function(state){
                        if (runif(1) <= self$epsilon){
                          return(sample(self$action_size, 1))
                        } else {
                          act_values <- predict(self$model, state)
                          return(which(act_values==max(act_values)))
                        }
                      },
                      replay = function(batch_size){
                        minibatch = sample(length(self$memory), batch_size) 
                        state = minibatch[1]
                        action = minibatch[2]
                        target = minibatch[3]
                        next_state = minibatch[4]
                        done = minibatch[5]
                        if (done == FALSE){
                          target = (target + self$gamma *
                                      max(predict(self$model, next_state)))
                          target_f = predict(self$model, state)
                          target_f[0][action] = target
                          self$model(state, target_f, epochs=1, verbose=0)
                        }
                        if (self$epsilon > self$epsilon_min){
                          self$epsilon = self$epsilon * self$epsilon_decay
                        }
                      },
                      load = function(name) {
                        self$model %>% load_model_tf(name)
                      },
                      save = function(name) {
                        self$model %>% save_model_tf(name)
                      }
                    )
)