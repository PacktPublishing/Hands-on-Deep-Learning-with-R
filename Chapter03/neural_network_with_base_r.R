# neural network function

# the neuron - where weights are applied to input 
# and the product is evaluated to determine if it is over a given threshold
artificial_neuron <- function(input) {
  as.vector(ifelse(input %*% weights > 0, 1, 0)) 
}

# draw lines using learned weights 
linear_fits <- function(w, to_add = TRUE, line_type = 1) {
  curve(-w[1] / w[2] * x - w[3] / w[2], xlim = c(-1, 2), ylim = c(-1, 2), col = "black",lty = line_type, lwd = 2, xlab = "Input Value A", ylab = "Input Value B", add = to_add)
}

# set the initial values
input <- matrix(c(1, 0,
                  0, 0,
                  1, 1,
                  0, 1), ncol = 2, byrow = TRUE)  
input <- cbind(input, 1) 
output <- c(0, 1, 0, 1)
weights <- c(0.12, 0.18, 0.24)
learning_rate <- 0.2

# add the first line
linear_fits(weights, to_add = FALSE)
points(input[ , 1:2], pch = (output + 21))

# update weights based on whether first set of weights passed through the artificial neuron
weights <- weights + learning_rate * (output[1] - artificial_neuron(input[1, ])) * input[1, ]
linear_fits(weights)

# draw a line with the updated weights and repeat this step with continually updated weights three more times
weights <- weights + learning_rate * (output[2] - artificial_neuron(input[2, ])) * input[2, ]
linear_fits(weights)


weights <- weights + learning_rate * (output[3] - artificial_neuron(input[3, ])) * input[3, ]
linear_fits(weights)


weights <- weights + learning_rate * (output[4] - artificial_neuron(input[4, ])) * input[4, ]
linear_fits(weights, line_type = 2) # this line bisects the two classes and is thus a solution to our problem