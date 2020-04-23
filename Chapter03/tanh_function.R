vals <- tibble(x = seq(-10, 10, 1), tanh_x = tanh(seq(-10, 10, 1)))

p <- ggplot(vals, aes(x, tanh_x))

p <- p + geom_point()
p + stat_function(fun = tanh, n = 1000) 

