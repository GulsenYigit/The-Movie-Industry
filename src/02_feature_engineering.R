# --- Setup ---
# Load the packages
library(tidyverse)
library(car)

# --- Input ---
df <- read.csv("../gen/temp/df_no_duplicates.csv") 


# --- Transformation ---

# Check the missing values for each column before handling NAs 
colSums(is.na(df)) # Opening Weekend has only 2 missing values so these can be dropped. Variables with more extensive missing data require imputation. 

# Drop the two missing values of opening revenue
df <- df %>% drop_na(opening_weekend) 


# Numerical columns that need missing value imputation
num_cols <- c("actor_rank_1", "actor_total_box_office_1", "actor_avg_per_film_1",
              "actor_rank_actor2", "actor_total_box_office_actor2", "actor_avg_per_film_actor2",
              "actor_rank_actor3", "actor_total_box_office_actor3", "actor_avg_per_film_actor3",
              "actor_rank_actor4", "actor_total_box_office_actor4", "actor_avg_per_film_actor4", "tomatoMeter")



# Replace missing values in numerical columns with the median of each column
for (col in num_cols) {
  df[[col]][is.na(df[[col]])] <- median(df[[col]], na.rm = TRUE)
}


# --- Operationalization of Genre Familiarity ---

# Ensure missing values in genre_2, genre_3, and genre_4 are handled
df$genre_2[df$genre_2 == ""] <- NA
df$genre_2[df$genre_2 == " "] <- NA
df$genre_3[df$genre_3 == ""] <- NA
df$genre_3[df$genre_3 == " "] <- NA
df$genre_4[df$genre_4 == ""] <- NA
df$genre_4[df$genre_4 == " "] <- NA

# Function to replace NA values in categorical columns with the most frequent value (mode)
replace_na_mode <- function(column) {
  mode_val <- names(sort(table(column), decreasing = TRUE))[1]  # Get mode
  column[is.na(column)] <- mode_val
  return(column)
}

# Apply function to all genre columns
df$genre_2 <- replace_na_mode(df$genre_2)
df$genre_3 <- replace_na_mode(df$genre_3)
df$genre_4 <- replace_na_mode(df$genre_4)

# Step 1: Combine genre_1, genre_2, genre_3, and genre_4 into one column to calculate frequencies
genre_counts <- df %>%
  pivot_longer(cols = c(genre_1, genre_2, genre_3, genre_4), 
               names_to = "genre_type", 
               values_to = "genre_name") %>%
  filter(!is.na(genre_name)) %>%
  count(genre_name)  # Count occurrences of each genre


# Step 2: Calculate the total number of genre occurrences
total_genre_count <- sum(genre_counts$n)


# Step 3: Calculate the relative genre familiarity (proportion)
genre_counts$genre_familiarity <- genre_counts$n / total_genre_count


# Step 4: Merge back the genre familiarity score into the original dataset for all four genres
df <- df %>%
  left_join(genre_counts, by = c("genre_1" = "genre_name")) %>%
  rename(genre_familiarity_1 = genre_familiarity) %>%
  left_join(genre_counts, by = c("genre_2" = "genre_name")) %>%
  rename(genre_familiarity_2 = genre_familiarity) %>%
  left_join(genre_counts, by = c("genre_3" = "genre_name")) %>%
  rename(genre_familiarity_3 = genre_familiarity) %>%
  left_join(genre_counts, by = c("genre_4" = "genre_name")) %>%
  rename(genre_familiarity_4 = genre_familiarity)


# Step 5: Compute total genre familiarity for each movie (sum of all four genres)
df$genre_familiarity <- rowSums(df[, c("genre_familiarity_1", "genre_familiarity_2", "genre_familiarity_3", "genre_familiarity_4")], na.rm = TRUE)
df$genre_familiarity <- pmin(df$genre_familiarity, 1)


# Scale genre familiarity from 0–1 to 0–100
df$genre_familiarity <- df$genre_familiarity * 100


# --- Operationalization of Star Power ---

# Compute star power (taking ensemble casting into account) 
df$star_power <- rowMeans(df[, c("actor_avg_per_film_1", "actor_avg_per_film_actor2",
                                 "actor_avg_per_film_actor3",
                                 "actor_avg_per_film_actor4")], na.rm = TRUE)

# --- Output ---

# Save the transformed df
write.csv(df, "../gen/temp/df_transformed.csv", row.names = FALSE)