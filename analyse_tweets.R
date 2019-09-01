# First attempt to anaylse the Tweets

library(twitteR)
library(tidyverse)
library(dplyr)
library(lubridate)
library(ggplot2)

PROJECT_DIR <- "c:/R/MAD_Social"
DATA_DIR    <- "c:/R/MAD_Social/data"

# Load the existing tweets

load('ATO_tweets',file=paste0(DATA_DIR,'/ATO_tweets.RData'))

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

# Find Other Hashtagsin the tweets
# Using the code from the Follow Me presentation:

# Classify Tweets by Sentiment
# Compare hashtag average sentiment to average
