state_size = 2
action_size = 20
agent = DQNAgent(state_size, action_size)

env = makeEnvironment(step = step, reset = reset)

done = FALSE
batch_size = 32