# First attempt to anaylse the Tweets

library(twitteR)
library(tidyverse)
library(dplyr)
library(lubridate)

PROJECT_DIR <- "c:/R/MAD_Social"
DATA_DIR    <- "c:/R/MAD_Social/data"

# Load the existing tweets

#Get the file names in the data directory
file_names <- list.files(path = file.path(DATA_DIR),
                   pattern="ATO_tweets_20..-..-...RData",full.names = TRUE)

load(file_names[1])  # Load the first data file.

ATO_tweets <- d_tweets  #  Initialise the ATO Tweets file with the first data file

# Add the rest of the files to the data file
for(i in 2:length(file_names)){
  load(file_names[i])
  ATO_tweets <- rbind(ATO_tweets,d_tweets)
}

save('ATO_tweets',file=paste0(DATA_DIR,'/ATO_tweets.RData'),version=2)
