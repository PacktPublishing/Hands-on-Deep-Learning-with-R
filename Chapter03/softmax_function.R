softmax <- function(x) {exp(x) / sum(exp(x))}

results <- softmax(c(2,3,6,9))
results

# [1] 0.0008658387 0.0023535935 0.0472731888 0.9495073791

sum(results)

# [1] 1