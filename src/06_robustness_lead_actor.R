# --- Setup ---
# Load the packages
library(tidyverse)
library(car)
library(sandwich)
library(lmtest)
library(modelsummary)
library(stargazer)


# --- Input ---
df <- read.csv("../gen/output/df_model.csv")

# Overwrite star_power to only use lead actor
df$star_power <- df$actor_avg_per_film_1
df$log_star_power <- log(df$star_power + 1)

# Standardize the updated star_power variable
df$z_log_star_power <- scale(df$log_star_power)[, 1]

# Recalculate the interaction term with standardized variables
df$interaction_z <- df$z_log_star_power * df$z_genre_familiarity

# Model with updated star_power
model_3 <- lm(log_opening_weekend ~ z_log_star_power + z_genre_familiarity + 
                interaction_z + z_tomatoMeter + z_log_production_budget, data = df)
summary(model_3)

# Calculate robust standard errors
robust_se <- coeftest(model_3, vcov = vcovHC(model_3, type = "HC3"))

# Print results
print(robust_se)
