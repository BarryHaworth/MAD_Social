# First Program to harvest tweets
# Code copied from the Follow Me presentation

install.packages("twitteR")
install.packages("wordcloud2")
install.packages("tidyverse")
install.packages("tidytext")
install.packages("knitr")
install.packages("plotly")
devtools::install_github("ropenscilabs/icon") # to insert icons
devtools::install_github("hadley/emo") # to insert emoji

library(knitr)
library(magick)
library(png)
library(grid)
library(emo)
library(icon)
library(twitteR)
library(tidyverse)
