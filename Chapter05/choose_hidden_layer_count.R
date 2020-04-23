length(train)*.66 

possible_node_values <- c(50,60,70,80,90)

mx.set.seed(0) 

model <- mx.mlp(data.matrix(train), 
                train_target, 
                hidden_node=70,
                out_node=2, 
                out_activation="softmax",
                num.round=10, 
                array.batch.size=32, 
                learning.rate=0.1, 
                momentum=0.8, 
                eval.metric=mx.metric.accuracy)

preds = predict(model, data.matrix(test))
pred.label = max.col(t(preds))-1

acc = sum(pred.label == test_target)/length(test_target)

vals <- tibble( 
  nodes = 70, 
  accuracy = acc 
)

vals

mlp_loop <- function(x) {  
  model <- mx.mlp(data.matrix(train), 
                  train_target, 
                  hidden_node=x, 
                  out_node=2, 
                  out_activation="softmax", 
                  num.round=10, 
                  array.batch.size=32, 
                  learning.rate=0.1, 
                  momentum=0.8,
                  eval.metric=mx.metric.accuracy)  
  preds = predict(model, data.matrix(test))  
  pred.label = max.col(t(preds))-1  
  acc = sum(pred.label == test_target)/length(test_target)  
  vals <- tibble(    
    nodes = x,   
    accuracy = acc  
  ) 
}

results <- mlp_loop(70)
results
all.equal(results$accuracy,acc)

results <- map_df(possible_node_values, mlp_loop)
results

data <- mx.symbol.Variable("data") 
fc1 <- mx.symbol.FullyConnected(data, num_hidden=90) 
fc2 <- mx.symbol.FullyConnected(fc1, num_hidden=50) 
smx <- mx.symbol.SoftmaxOutput(fc2)

model <- mx.model.FeedForward.create(smx, 
                                     data.matrix(train), 
                                     train_target,num.round=10, 
                                     array.batch.size=32, 
                                     learning.rate=0.1, 
                                     momentum=0.8, 
                                     eval.metric=mx.metric.accuracy)

preds = predict(model, data.matrix(test))
pred.label = max.col(t(preds))-1
acc = sum(pred.label == test_target)/length(test_target)
acc