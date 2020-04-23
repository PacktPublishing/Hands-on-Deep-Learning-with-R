# load library
library(ReinforcementLearning)

# create a sample environment
data <- sampleGridSequence(N = 1000)

# set how the agent will learn
control <- list(alpha = 0.1, gamma = 0.1, epsilon = 0.1)

# fit the model
model <- ReinforcementLearning(data, s = "State", a = "Action", r = "Reward", 
                               s_new = "NextState", control = control)

# print the results
print(model)