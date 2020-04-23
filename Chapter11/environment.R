reset = function(self) {
  position = runif(1, -0.6, -0.4)
  velocity = 0
  state = matrix(c(position, velocity), ncol = 2)
  state
}

step = function(self, action) {
  position = self$state[1]
  velocity = self$state[2]
  velocity = (action - 1L) * 0.001 + cos(3 * position) * (-0.0025)
  velocity = min(max(velocity, -0.07), 0.07)
  position = position + velocity
  if (position < -1.2) {
    position = -1.2
    velocity = 0
  }
  state = matrix(c(position, velocity), ncol = 2)
  reward = -1
  if (position >= 0.5) {
    done = TRUE
    reward = 0
  } else {
    done = FALSE
  }
  list(state, reward, done)
}