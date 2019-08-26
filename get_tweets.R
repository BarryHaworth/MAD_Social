# First Program to harvest tweets
# Code copied from the Follow Me presentation, UseR! 2018

library(twitteR)
library(tidyverse)
library(dplyr)
library(lubridate)

PROJECT_DIR <- "c:/R/MAD_Social"
DATA_DIR    <- "c:/R/MAD_Social/data"

source("Auth.R")

# Get new tweets
ATO_tweet_list <- searchTwitter('#ATO', resultType="recent", n=1000)  # 1000 requested 617 returned on 26/08/2019.  All appear to be english
ATO_tweets <- twListToDF(ATO_tweet_list)

ATO_tweets <- ATO_tweets %>% mutate(date = date(created))  %>% distinct()

dates <- unique(ATO_tweets$date)

summary(date(ATO_tweets$created))

for(d in dates) {
  d <- as.Date(d, origin = "1970-01-01")
  print(paste("Date is",d))
  d_tweets <- ATO_tweets %>% filter(date == d)
  save('d_tweets',file=paste0(DATA_DIR,'/ATO_tweets_',d,'.RData'))
}

save('ATO_tweets',file=paste0(DATA_DIR,'/ATO_tweets.RData'))

