dbn <- dbn.dnn.train(x = as.matrix(train_x), y = train_y, hidden = c(100,50,10), cd = 1, numepochs = 5)

predictions <- nn.predict(dbn, as.matrix(test_x))

pred_class <- if_else(predictions > 0.3, 1, 0)
table(test_y,pred_class)