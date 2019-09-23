# Install packages
install.packages("tidyverse")
install.packages("magrittr")

# Load libaries
library(tidyverse)
library(magrittr)

# Load data
df <- read_xlsx("/data/Khoros/2019.01-Lithium-Raw-Data.xlsm") %>%
  select(Source, Content) %>%
  rbind(read_xlsx("/data/Khoros/2019.02-Lithium-Raw-Data.xlsm") %>%
          select(Source, Content)) %>%
  rbind(read_xlsx("/data/Khoros/2019.03-Lithium-Raw-Data.xlsm") %>%
          select(Source, Content)) %>%
  rbind(read_xlsx("/data/Khoros/2019.04-Lithium-Raw-Data.xlsm") %>%
          select(Source, Content)) %>%
  rbind(read_xlsx("/data/Khoros/2019.05-Khoros-Raw-Data.xlsm") %>%
          select(Source, Content)) %>%
  rbind(read_xlsx("/data/Khoros/2019.06-Khoros-Raw-Data.xlsm") %>%
          select(Source, Content)) %>%
    rbind(read_xlsx("/data/Khoros/2019.07-Khoros-Raw-Data.xlsm") %>%
          select(Source, Content))

# Clean data
df <- df %>%
  filter(!is.na(Content))
