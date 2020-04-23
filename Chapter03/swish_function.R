# if the sigmoid function is not still in your environment then add it back
sigmoid = function(x) {
  1 / (1 + exp(-x))
}

swish <- function(x){x * sigmoid(x)}

vals <- tibble(x = seq(-10, 10, 1), swish_x = swish(seq(-10, 10, 1)))

p <- ggplot(vals, aes(x, swish_x))
p <- p + geom_point()
p + geom_line() 