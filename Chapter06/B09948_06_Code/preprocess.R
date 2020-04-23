library(keras)
library(tidyverse)
library(knitr)

steamdata <- read_csv("data/steam-200k.csv", col_names=FALSE)

glimpse(steamdata)

colnames(steamdata) <- c("user", "item", "interaction", "value", "blank")

steamdata <- steamdata %>% 
  filter(interaction == "play") %>%
  select(-blank) %>%
  select(-interaction) %>% 
  mutate(item = str_replace_all(item,'[ [:blank:][:space:] ]',""))

users <- steamdata %>% select(user) %>% distinct() %>% rowid_to_column()
steamdata <- steamdata %>% inner_join(users) %>% rename(userid=rowid)

items <- steamdata %>% select(item) %>% distinct() %>% rowid_to_column()
steamdata <- steamdata %>% inner_join(items) %>% rename(itemid=rowid)

steamdata <- steamdata %>% rename(title=item, rating=value)

n_users <- steamdata %>% select(userid) %>% distinct() %>% nrow()
n_items <- steamdata %>% select(itemid) %>% distinct() %>% nrow()

# normalize data with min-max function
minmax <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# add scaled rating value
steamdata <- steamdata %>% mutate(rating_scaled = minmax(rating))

# split into training and test
index <- sample(1:nrow(steamdata), 0.8* nrow(steamdata))
train <- steamdata[index,] 
test <- steamdata[-index,] 

# create matrices of user, items, and ratings for training and test 
x_train <- train %>% select(c(userid, itemid)) %>% as.matrix()
y_train <- train %>% select(rating_scaled) %>% as.matrix()
x_test <- test %>% select(c(userid, itemid)) %>% as.matrix()
y_test <- test %>% select(rating_scaled) %>% as.matrix()