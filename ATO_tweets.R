# First Program to harvest tweets
# Code copied from the Follow Me presentation, UseR! 2018

install.packages("twitteR")
install.packages("wordcloud2")
install.packages("tidyverse")
install.packages("tidytext")
install.packages("knitr")
install.packages("plotly")

library(knitr)
library(magick)
library(png)
library(grid)
library(twitteR)
library(tidyverse)

# Search tweets
# ATO_tweet_list <- searchTwitter('#ATO',lang = "en",n=1000)  # 1000 requested 408 returned on 26/08/2019
ATO_tweet_list <- searchTwitter('#ATO',n=1000)  # 1000 requested 617 returned on 26/08/2019.  All appear to be english
ATO_tweets <- twListToDF(ATO_tweet_list)

summary(ATO_tweets$created)

save('ATO_tweets',file='./data/ATO_tweets.RData')

#  Identify Hastags

library(wordcloud2)

all_hash <- all_words %>% 
  filter(!(word %in% str_to_lower(Hashtags$Hashtags))) %>%
  filter(str_detect(string = word, pattern = "#")) %>%
  group_by(word) %>%
  count() %>%
  filter(n > 80) %>%
  ungroup() %>%
  mutate(word = reorder(word,n)) %>%
  arrange(desc(word)) %>%
  rename(freq = n) 

wordcloud2(all_hash)

# Sentiment


