state = reset(env)
for (j in 1:5000) {
  action = agent$act(state)
  nrd = step(env,action)
  next_state = unlist(nrd[1])
  reward = as.integer(nrd[2])
  done = as.logical(nrd[3])
  next_state = matrix(c(next_state[1],next_state[2]), ncol = 2)
  reward = dplyr::if_else(done == TRUE, reward, as.integer(-10))
  agent$memorize(state, action, reward, next_state, done)
  state = next_state
  env$state = next_state
  if (done == TRUE) {
    cat(sprintf("score: %d, e: %.2f",j,agent$epsilon))
    break
  } 
  if (length(agent$memory) > batch_size) {
    agent$replay(batch_size)
  } 
  if (j %% 10 == 0) {
    cat(sprintf("try: %d, state: %f,%f  ",j,state[1],state[2]))  
  }
  
}
