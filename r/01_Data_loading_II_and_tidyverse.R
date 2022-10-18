###########################################################################
######################      R for Env Sci - Week 03    ####################
###############       01_Data_loading_II_and_tidyverse        #############
###########################################################################

## Let's start with a black slate - Let's re-start the R session   <- CAREFUL!!! do it at your own risk!

# Ctrl + Shift + Fn + F10  (PC / Linux)
# Command + Shift + Fn+ F10 (Mac OS)


# Load required packages --------------------------------------------------

library(tidyverse)
library(janitor)
library(here)


# Data input output -------------------------------------------------------

# so far, the traditional way

data_a <- read.csv("data/example_data_set_a.csv")

read.csv(here("data/example_data_set_a.csv"))

read.csv(here("data", "example_data_set_a.csv"))


data_a

head(data_a)
str(data_a)

# the Tidyverse way with read_csv() from {readr}
# Produces a Tibble!

data_b <- read_csv("data/example_data_set_a.csv")

data_b

# Plus many other benefits you don't see (it is better at detecting and parsing dates from the start for example)
# Check them in the environment



# Lets look at some real data ---------------------------------------------

# Data, from 
# Zuur, Alain, Elena N. Ieno, and Graham M. Smith. Analyzing ecological data. Springer, 2007.


ditch_data_original <- read_delim("data/ditch.txt", delim = "\t")

ditch_data_original

# Tidiverse comes with glimpse(), very useful

glimpse(ditch_data_original)


## Those variable names do not follow the tidyverse style guide! lets fix it!
## LEts use the clean_names() function from {janitor}

clean_names(ditch_data_original) 

# Let's practice with the pipe

ditch_data_original %>% 
  clean_names()


# very useful when you want to add many functions


ditch_data <- ditch_data_original %>% 
  clean_names() %>%
  rename(ph = p_h)

ditch_data

glimpse(ditch_data)

# Data input tricks


read_csv("data/weather.csv")


weather_data <- read_csv("data/weather.csv", skip = 25)


weather_data


glimpse(weather_data)


weather_data <- weather_data %>% 
  clean_names()


glimpse(weather_data)




# Selecting, and moving things around -------------------------------------


# select columns


# you can create a subset of columns

subset <- ditch_data %>% 
  dplyr::select(site, year, month, depth, ph, conductivity)

subset

# you can get rid of one or several columns

everything_minus_depth <- ditch_data %>% 
  select(-depth)

everything_minus_depth


# you can reorder columns

ditch_data %>% 
select(year, month, everything())



# arrange/sort data

ditch_data %>% 
  arrange(year)

ditch_data %>% 
  arrange(desc(year))



# filter data (rows)

ditch_data %>% 
  filter(year == 2001)


ditch_data %>% 
  filter(site != 1)



# create new columns (mutate)


ditch_data <- ditch_data %>% 
  mutate(watershed = "Watershed XXX") 

glimpse(ditch_data)



# Summarising things ------------------------------------------------------

# Base r has a nice summary function

ditch_data %>% 
  summary()

# But it summarises every column, and it is hard to do manipulate the results downstream
# what if we want a specific subset, or to keep it so we can use it down the line

ph_summary <- ditch_data %>% 
  summarise(mean_ph = mean(ph),
            sd_ph = sd(ph))

ph_summary

# Be careful with NAs

ditch_data %>% 
  summarise(mean_depth = mean(depth),
            sd_depth = sd(depth))

ditch_data %>% 
  summarise(mean_depth = mean(depth, na.rm = TRUE),
            sd_depth = sd(depth, na.rm = TRUE))


# Pivoting ----------------------------------------------------------------


ditch_data

ditch_data_long <- ditch_data %>% 
  pivot_longer(cols = c(-site, -month, -year, -depth, -watershed), 
               names_to = "parameter", 
               values_to = "measure")

ditch_data_long


# Example of a very tipycal workflow
# What if i want to know if there are any temporal trends in the different parameters

summary_table <- ditch_data_long %>%
  group_by(parameter) %>%
  summarise(mean_value = mean(measure, na.rm = TRUE),
            sd_value = sd(measure, na.rm = TRUE))

summary_table

  
  
  


