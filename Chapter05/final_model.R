model <- mx.mlp(data.matrix(train), 
                train_target, 
                hidden_node=90, 
                out_node=2, 
                out_activation="softmax",
                num.round=200, 
                array.batch.size=32, 
                learning.rate=0.005, 
                momentum=0.8,
                eval.metric=mx.metric.accuracy)
preds = predict(model, data.matrix(test))
pred.label = max.col(t(preds))-1
acc = sum(pred.label == test_target)/length(test_target)
acc