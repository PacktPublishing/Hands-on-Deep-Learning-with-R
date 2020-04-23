twenty_newsgroups$text[400]

sentences <- tibble(text = twenty_newsgroups$text[400]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(id = row_number()) %>%
  select(id, sentence)

words <- sentences %>%
  unnest_tokens(word, sentence)

article_summary <- textrank_sentences(data = sentences, terminology = words)

article_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  top_n(1) %>%
  pull(sentence)