model <- keras_model_sequential()

model %>%
  layer_lstm(units = 4,
             input_shape = c(3, 1)) %>%
  layer_dense(units = 1)

model %>%
  compile(loss = 'mse', optimizer = 'adam')

model

history <- model %>% fit_generator(
  train_gen,
  epochs = 100,
  steps_per_epoch=1,
  verbose=2
)

testpredict <- predict_generator(model, test_gen, steps = 200)
trainpredict <- predict_generator(model, train_gen, steps = 1200)

trainpredict <- data.frame(pred = trainpredict)
rownames(trainpredict) <- index(closing_deltas)[4:1203]
trainpredict <- as.xts(trainpredict)

testpredict <- data.frame(pred = testpredict)
rownames(testpredict) <- index(closing_deltas)[1262:1461]
testpredict <- as.xts(testpredict)

closing_deltas$trainpred <- rep(NA,1507)
closing_deltas$trainpred[4:1203] <- trainpredict$pred

closing_deltas$testpred <- rep(NA,1507)
closing_deltas$testpred[1262:1461] <- testpredict$pred

plot(as.zoo(closing_deltas), las=1, plot.type = "single", col = c("light gray","black","black"), lty = c(3,1,1))

evaluate_generator(model, test_gen, steps = 200)
evaluate_generator(model, train_gen, steps = 1200)
