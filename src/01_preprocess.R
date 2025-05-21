# --- Setup ---
# Load the package
library(tidyverse)

# --- Input ---
df_raw <- read.csv("../data/df_raw.csv")

# --- Transformation --- (Remove duplicates based on 'movie_id' and drop unnecessary columns)
df_no_duplicates <- df_raw %>%
  distinct(movie_id, movie_year, .keep_all = TRUE) %>%
  dplyr::select(-c(X, X.1, X.2, director, writer, composer, producer, cinematographer, link,
            domestic, international, worldwide, audienceScore,
            run_time, genre, mpaa, runtimeMinutes))

# --- Output --- (Save the df with no duplicates)
dir.create("../gen/temp", recursive = TRUE) 
write.csv(df_no_duplicates, "../gen/temp/df_no_duplicates.csv", row.names = FALSE)

