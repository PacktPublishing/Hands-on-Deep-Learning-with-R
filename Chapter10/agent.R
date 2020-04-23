library(hash)
Q <- hash()
for (i in unique(tictactoe$State)[!unique(tictactoe$State) %in% names(Q)]) { Q[[i]] <- hash(unique(tictactoe$Action), rep(0, length(unique(tictactoe$Action)))) } 

control = list( 
  alpha = 0.1, 
  gamma = 0.1, 
  epsilon = 0.1 
) 

d <- tictactoe[1, ]  
state <- d$State  
action <- d$Action  
reward <- d$Reward  
nextState <- d$NextState 

currentQ <- Q[[state]][[action]]  
if (has.key(nextState,Q)) {
  maxNextQ <- max(values(Q[[nextState]]))  
} else {    
  maxNextQ <- 0  
} 


## Bellman equation  
Q[[state]][[action]] <- currentQ + control$alpha *    (reward + control$gamma * maxNextQ - currentQ)
q_value <- Q[[tictactoe$State[1]]][[tictactoe$Action[1]]] 


for (i in 1:nrow(tictactoe)) {  
  d <- tictactoe[i, ]  
  state <- d$State  
  action <- d$Action  
  reward <- d$Reward  
  nextState <- d$NextState  
  currentQ <- Q[[state]][[action]]  
  if (has.key(nextState,Q)) {    
    maxNextQ <- max(values(Q[[nextState]]))  
  } else {    
    maxNextQ <- 0  
  }  ## Bellman equation  
  Q[[state]][[action]] <- currentQ + control$alpha *    (reward + control$gamma * maxNextQ - currentQ) 
}

Q[[tictactoe$State[234543]]][[tictactoe$Action[234543]]] 