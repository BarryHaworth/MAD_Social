# First attempt to anaylse the Tweets

library(twitteR)
library(tidyverse)
library(tidytext)
library(dplyr)
library(lubridate)
library(ggplot2)
library(stringr)
library(wordcloud)
library(wordcloud2)
library(syuzhet)  # Sentiment Analysis


#PROJECT_DIR <- "/home/RADLAB/ruca78/sentiment-analysis-research"
#DATA_DIR    <- "/data/group3/tweets"
PROJECT_DIR <- "c:/R/MAD_Social"
DATA_DIR    <- "c:/R/MAD_Social/data"

# Load the existing tweets

load(file=paste0(DATA_DIR,'/ATO_tweets.RData'))

summary(ATO_tweets)

#  Analysis to try:
# plot number of tweets by day

ggplot(data=ATO_tweets, aes(date)) + 
  geom_histogram(binwidth=1,
                 col="blue", 
                 fill="blue", 
                 alpha = .2) + 
  labs(title="Number of Tweets by Date") +
  labs(x="Date", y="Count") 

# Using the code from the Follow Me presentation:
## Step 2: Convert tweets to the tidy text format: `tidytext::unnest_token`

#  Add Retweet indicators
reg_retweets <- "^RT @(\\w+)"
ATO_tweets <- ATO_tweets %>% 
  mutate(tweetID = 1:n()) %>% 
  mutate(retweet_from = str_extract(text, reg_retweets)) %>%
  mutate(retweet_from = str_replace_all(retweet_from, "^RT ", ""))

head(ATO_tweets[,c("tweetID","retweet_from","isRetweet")])

# Convert to Tidytext Format

replace_reg <- "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https"
unnest_reg <- "([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"

all_words <- ATO_tweets %>% 
  filter(!duplicated(ATO_tweets)) %>% 
  mutate(text = str_replace_all(text, replace_reg, "")) %>%
  unnest_tokens(word, text, token = "regex", pattern = unnest_reg) %>%
  filter(!word %in% stop_words$word,str_detect(word, "[a-z]")) %>% 
  filter(!(word==retweet_from))

head(all_words[,c("word","tweetID")])

save('all_words',file=paste0(DATA_DIR,'/all_words.RData'),version=2)

# Find Other Hashtags in the tweets

all_hash <- all_words %>% 
  filter( word!="#ato" ) %>%
  filter(str_detect(string = word, pattern = "#")) %>%
  group_by(word) %>%
  count() %>%
  filter(n > 4) %>%
  ungroup() %>%
  mutate(word = reorder(word,n)) %>%
  arrange(desc(word)) %>%
  rename(freq = n) 

head(all_hash,n=20)

wordcloud(all_hash$word,all_hash$freq) # Basci version wordcloud
wordcloud2(all_hash) # Wordcloud 2.  Some words obscured

# Wordcloud highlights some words that don't associate with 
# Australian Taxation Office, but with a different ATO.  Need to remove these.


# Classify Tweets by Sentiment
# Using code from the Whats_app.R program

Sentiment <- get_nrc_sentiment(ATO_tweets$text)
head(Sentiment)
ATO_tweets <- cbind(ATO_tweets,Sentiment)

# Compare hashtag average sentiment to average
