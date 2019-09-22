# Sentiment Analysis of #ATO Tweets
# using code from https://www.kaggle.com/rtatman/tutorial-sentiment-analysis-in-r

# load in the libraries we'll need
library(tidyverse)
library(tidytext)
library(glue)
library(stringr)

# Set environmentvariables.
#PROJECT_DIR <- "/home/RADLAB/ruca78/sentiment-analysis-research"
#DATA_DIR    <- "/data/group3/tweets"
PROJECT_DIR <- "c:/R/MAD_Social"
DATA_DIR    <- "c:/R/MAD_Social/data"

# Load the existing tweets

load(file=paste0(DATA_DIR,'/ATO_tweets.RData'))

summary(ATO_tweets)

library(syuzhet)  # Sentiment Analysis
# Classify Tweets by Sentiment
# Using code from the Whats_app.R program

Sentiment <- get_nrc_sentiment(ATO_tweets$text)
head(Sentiment[c('negative','positive')])
ATO_tweets <- cbind(ATO_tweets,Sentiment[c('negative','positive')])
head(ATO_tweets[c('text','negative','positive')])

ATO_tweets <- ATO_tweets %>% mutate(sentiment = positive - negative)
summary(ATO_tweets$sentiment)

ggplot(data=ATO_tweets, aes(sentiment)) + 
  geom_histogram(binwidth=1,
                 col="blue", 
                 fill="blue", 
                 alpha = .2) + 
  labs(title="Number of Tweets by Sentiment score") +
  labs(x="Date", y="Count") 

# plot of sentiment over time & automatically choose a method to model the change
ggplot(ATO_tweets, aes(x = date, y = sentiment)) + 
  labs(title="Sentiment over time") +
  geom_smooth(method = "loess") # pick a method & fit a model

ggplot(ATO_tweets[ATO_tweets$sentiment != 0,], aes(x = date, y = sentiment)) + 
  #  geom_point(aes(color = president))+ # add points to our plot, color-coded by president
  labs(title="Sentiment over time, excluding neutral") +
  geom_smooth(method = "loess") # pick a method & fit a model

# Hashtags

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

save('all_words',file=paste0(DATA_DIR,'/all_words.RData'))

# Find Other Hashtags in the tweets

all_hash <- all_words %>% 
  filter( word!="#ato" ) %>%
  filter(str_detect(string = word, pattern = "#")) %>%
  group_by(word) %>%
  summarize(Mean = mean(sentiment, na.rm=TRUE),
            n = length(sentiment)) %>%
  filter(n > 20) %>%
  ungroup() %>%
  mutate(word = reorder(word,n)) %>%
  arrange(desc(word)) %>%
  rename(freq = n,
         Sentiment = Mean,
         hashtab = word) 

head(all_hash,n=20)

# Average Sentiment
mean(ATO_tweets$sentiment)

