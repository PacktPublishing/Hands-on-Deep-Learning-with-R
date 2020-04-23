# user-item interaction exploratory data analysis (EDA)
item_interactions <- aggregate(
  rating ~ title, data = steamdata, FUN = 'sum')
item_interactions <- item_interactions[
  order(item_interactions$rating, decreasing = TRUE),]
item_top10 <- head(item_interactions, 10)
kable(item_top10)


# average gamplay
steamdata %>% summarise(avg_gameplay = mean(rating))

# median gameplay
steamdata %>% summarise(median_gameplay = median(rating))

# top game by individual hours played
topgame <- steamdata %>% arrange(desc(rating)) %>% top_n(1,rating)

# show top game by individual hours played
kable(topgame)


# top 10 games by hours played
mostplayed <- 
  steamdata %>%
  group_by(item) %>%
  summarise(hrs=sum(rating)) %>% 
  arrange(desc(hrs)) %>%
  top_n(10, hrs) %>%
  ungroup

# show top 10 games by hours played
kable(mostplayed)

# reset factor levels for items
mostplayed$item <- droplevels(mostplayed$item)

# top 10 games by collective hours played
ggplot(mostplayed, aes(x=item, y=hrs, fill = hrs)) +
  aes(x = fct_inorder(item)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(size=8, face="bold", angle=90)) +
  theme(axis.ticks = element_blank()) +
  scale_y_continuous(expand = c(0,0), limits = c(0,1000000)) + 
  labs(title="Top 10 games by collective hours played") +
  xlab("game") +
  ylab("hours")


# most popular games by total users
mostusers <-
  steamdata %>%
  group_by(item) %>%
  summarise(users=n()) %>% 
  arrange(desc(users)) %>% 
  top_n(10, users) %>% 
  ungroup

# reset factor levels for items
mostusers$item <- droplevels(mostusers$item)

# top 10 popular games by total users
ggplot(mostusers, aes(x=item, y=users, fill = users)) +
  aes(x = fct_inorder(item)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(size=8, face="bold", angle=90)) +
  theme(axis.ticks = element_blank()) +
  scale_y_continuous(expand = c(0,0), limits = c(0,5000)) + 
  labs(title="Top 10 popular games by total users") +
  xlab("game") +
  ylab("users")


summary(steamdata$value)


# plot item iteraction
ggplot(steamdata, aes(x=steamdata$value)) +
  geom_histogram(stat = "bin", binwidth=50, fill="steelblue") +
  theme(axis.ticks = element_blank()) +
  scale_x_continuous(expand = c(0,0)) + 
  scale_y_continuous(expand = c(0,0), limits = c(0,60000)) + 
  labs(title="Item interaction distribution") +
  xlab("Hours played") +
  ylab("Count")


# plot item iteraction with log transformation
ggplot(steamdata, aes(x=steamdata$value)) +
  geom_histogram(stat = "bin", binwidth=0.25, fill="steelblue") +
  theme(axis.ticks = element_blank()) +
  scale_x_log10() +
  labs(title="Item interaction distribution with log transformation") +
  xlab("log(Hours played)") +
  ylab("Count")