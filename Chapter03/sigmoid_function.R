sigmoid = function(x) {
  1 / (1 + exp(-x))
}

vals <- tibble(x = seq(-10, 10, 1), sigmoid_x = sigmoid(seq(-10, 10, 1)))

p <- ggplot(vals, aes(x, sigmoid_x))

p <- p + geom_point()
p + stat_function(fun = sigmoid, n = 1000)
