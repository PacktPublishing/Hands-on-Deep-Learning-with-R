leaky_relu <- function(x,a){dplyr::if_else(x > 0, x, x*a)}

vals <- tibble(x = seq(-10, 10, 1), leaky_relu_x = leaky_relu(seq(-10, 10, 1),0.01))

p <- ggplot(vals, aes(x, leaky_relu_x))
p <- p + geom_point()
p + geom_line() 

