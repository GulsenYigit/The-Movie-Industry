# --- Setup ---
# Load the necessary packages
library(tidyverse)


# --- Input ---
df <- read.csv("../gen/temp/df_transformed.csv") 

# --- Transformation ---

# Specify an initial model without log-transformations
model <- lm(opening_weekend ~ star_power * genre_familiarity + tomatoMeter + production_budget, data = df)


# --- Log Transformations ---

# Apply log transformation to opening weekend revenue, production budget, and star power to reduce skewness
df$log_opening_weekend <- log(df$opening_weekend + 1) # Adding 1 to avoid log(0)
df$log_production_budget <- log(df$production_budget + 1)  # Adding 1 to avoid log(0)
df$log_star_power <- log(df$star_power + 1)  # Adding 1 to avoid log(0)


# --- Standardization ---

# Standardize predictors as they are on different scales
df$z_log_star_power <- scale(df$log_star_power)[, 1]
df$z_genre_familiarity <- scale(df$genre_familiarity)[, 1]
df$z_log_production_budget <- scale(df$log_production_budget)[, 1]
df$z_tomatoMeter <- scale(df$tomatoMeter)[, 1]
df$interaction_z <- df$z_log_star_power * df$z_genre_familiarity


# --- Fit model with standardized predictors ---
model_log <- lm(log_opening_weekend ~ z_log_star_power + z_genre_familiarity + 
                  interaction_z + z_tomatoMeter + z_log_production_budget, data = df)
summary(model_log)


# --- Prepare final dataset ---
df_final <- df %>%
  dplyr::select(movie_id, movie_year, log_opening_weekend,
                z_log_star_power, z_genre_familiarity, interaction_z,
                z_log_production_budget, z_tomatoMeter,
                star_power, genre_familiarity, tomatoMeter, 
                production_budget, opening_weekend, log_production_budget, log_star_power, actor_avg_per_film_1)


# Remove any unwanted special characters from column names
colnames(df_final) <- gsub("\\.\\[1\\]", "", colnames(df_final))
colnames(df_final)


# --- Output ---
dir.create("../gen/output", recursive = TRUE)
write.csv(df_final, "../gen/output/df_model.csv", row.names = FALSE)
