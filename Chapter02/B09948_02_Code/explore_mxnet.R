## load the library
library(mxnet)

# set seed for reprodibility
mx.set.seed(0)

# fit a model
model <- mx.mlp(data.matrix(train), train_target, hidden_node=10, out_node=2, out_activation="softmax",
                num.round=10, array.batch.size=20, learning.rate=0.05, momentum=0.8,
                eval.metric=mx.metric.accuracy)

# make predictions
preds = predict(model, data.matrix(test))

# compare predictions with ground truth
pred.label = max.col(t(preds))-1
table(pred.label, test_target)