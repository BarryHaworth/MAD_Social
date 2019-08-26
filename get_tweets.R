# First Program to harvest tweets
# Code copied from the Follow Me presentation, UseR! 2018

library(twitteR)
library(tidyverse)
library(dplyr)
library(lubridate)

PROJECT_DIR <- "c:/R/MAD_Social"
DATA_DIR    <- "c:/R/MAD_Social/data"

source("Auth.R")

# Get existing tweets

file_names <- list.files(path = file.path(DATA_DIR),
                   pattern=".RData",full.names = TRUE)

load(file_names[1])

ATO_tweets <- d_tweets

for(i in 2:length(file_names)){
  load(file_names[i])
  ATO_tweets <- rbind(ATO_tweets,d_tweets)
}

# Get new tweets
new_tweet_list <- searchTwitter('#ATO', resultType="recent", n=1000)  
new_tweets <- twListToDF(new_tweet_list)

new_tweets <- new_tweets %>% mutate(date = date(created))  

ATO_tweets <- rbind(ATO_tweets,new_tweets) %>% distinct()

dates <- unique(ATO_tweets$date)

summary(date(ATO_tweets$created))

for(d in dates) {
  d <- as.Date(d, origin = "1970-01-01")
  print(paste("Date is",d))
  d_tweets <- ATO_tweets %>% filter(date == d)
  save('d_tweets',file=paste0(DATA_DIR,'/ATO_tweets_',d,'.RData'))
}



