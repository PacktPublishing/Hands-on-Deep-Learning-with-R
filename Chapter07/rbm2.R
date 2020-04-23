spam_vs_ham <- read.csv("spam.csv")

y <- if_else(spam_vs_ham$v1 == "spam", 1, 0)
x <- spam_vs_ham$v2 %>% 
  str_replace_all("[^a-zA-Z0-9/:-_]|\r|\n|\t", " ") %>% 
  str_replace_all("\b[a-zA-Z0-9/:-]{1,2}\b", " ") %>%
  str_trim("both") %>%
  str_squish()

corpus <- Corpus(VectorSource(x))
dtm <- DocumentTermMatrix(corpus)

split_ratio <- floor(0.75 * nrow(dtm))

set.seed(614)
train_index <- sample(seq_len(nrow(dtm)), size = split_ratio)

train_x <- dtm[train_index,]
train_y <- y[train_index]
test_x <- dtm[-train_index,]
test_y <- y[-train_index]

rbm3 <- rbm.train(x = as.matrix(train_x),hidden = 100,cd = 3,numepochs = 5)
rbm5 <- rbm.train(x = as.matrix(train_x),hidden = 100,cd = 5,numepochs = 5)
rbm1 <- rbm.train(x = as.matrix(train_x),hidden = 100,cd = 1,numepochs = 5)

rbm5$e[1:10]
rbm3$e[1:10]
rbm1$e[1:10]

train_latent_features <- rbm.up(rbm1, as.matrix(train_x))
test_latent_features <- rbm.up(rbm1, as.matrix(test_x))