library(tidyverse)
library(tidytext)
library(spacyr)
library(textmineR)

twenty_newsgroups <- read_csv("http://ssc.wisc.edu/~ahanna/20_newsgroups.csv")

twenty_newsgroups[1,]

word_tokens <- twenty_newsgroups %>%
  unnest_tokens(word, text)

word_tokens %>%
  group_by(word) %>%
  summarize(word_count = n()) %>%
  top_n(20) %>%
  ggplot(aes(x=reorder(word, word_count), word_count)) +
  xlab("word") +
  geom_col() +
  coord_flip() 

word_tokens <- word_tokens %>%
  filter(!word %in% stop_words$word)

word_tokens %>%
  group_by(word) %>%
  summarize(word_count = n()) %>%
  top_n(20) %>%
  ggplot(aes(x=reorder(word, word_count), word_count)) +
  xlab("word") +
  geom_col() +
  coord_flip()

word_tokens <- word_tokens %>%
  filter(str_detect(word, "^[a-z]+[a-z]$"))