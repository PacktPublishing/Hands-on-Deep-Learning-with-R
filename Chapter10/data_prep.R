library(ReinforcementLearning)
data("tictactoe")

head(tictactoe, 5)

tictactoe %>%  dplyr::filter(Reward == 1) %>%  head()
tictactoe %>%  dplyr::filter(Reward == -1) %>%  head()

tictactoe %>% dplyr::filter(State == 'XB..X.XBB') %>%  dplyr::distinct() 

State <- '0,0' 
Action <- '4' 
NextState <- '4,8' 
Reward <- 0
numberscramble <- tibble::tibble(  State = State,  Action = Action,  NextState = NextState,  Reward = Reward )
numberscramble