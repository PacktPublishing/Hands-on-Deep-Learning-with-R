relu <- function(x){dplyr::if_else(x > 0, x, 0)}

vals <- tibble(x = seq(-10, 10, 1), relu_x = relu(seq(-10, 10, 1)))

p <- ggplot(vals, aes(x, relu_x))
p <- p + geom_point()
p + geom_line() 