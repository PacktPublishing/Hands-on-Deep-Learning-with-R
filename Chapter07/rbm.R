library(tm)
library(deepnet)

corpus <- Corpus(VectorSource(twenty_newsgroups$text))

corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, c("the", "and", stopwords("english")))
corpus <- tm_map(corpus, stripWhitespace)

news_dtm <- DocumentTermMatrix(corpus, control = list(weighting = weightTfIdf))
news_dtm <- removeSparseTerms(news_dtm, 0.95)

split_ratio <- floor(0.75 * nrow(twenty_newsgroups))

set.seed(614)
train_index <- sample(seq_len(nrow(twenty_newsgroups)), size = split_ratio)

train_x <- news_dtm[train_index,]
train_y <- twenty_newsgroups$target[train_index]
test_x <- news_dtm[-train_index,]
test_y <- twenty_newsgroups$target[-train_index]

rbm <- rbm.train(x = as.matrix(train_x), hidden = 20, numepochs = 100)

test_latent_features <- rbm.up(rbm, as.matrix(test_x))