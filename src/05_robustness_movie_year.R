# --- Setup ---
# Load the packages
library(tidyverse)
library(car)
library(sandwich)
library(lmtest)


# --- Input ---
df <- read.csv("../gen/output/df_model.csv") 

# Create 5-year time periods (2000–2019)
df$movie_period <- cut(df$movie_year,
                       breaks = c(1999, 2004, 2009, 2014, 2019),
                       labels = c("early2000s", "late2000s", "early2010s", "late2010s"),
                       right = TRUE)

# Set reference level explicitly
df$movie_period <- relevel(df$movie_period, ref = "early2000s")

# Model with year as an additional control
model_2 <- lm(log_opening_weekend ~ z_log_star_power + z_genre_familiarity +
                interaction_z + z_tomatoMeter + z_log_production_budget +
                movie_period, data = df)
summary(model_2)

# Calculate robust standard errors
robust_se <- coeftest(model_2, vcov = vcovHC(model_2, type = "HC3"))

# Print results
print(robust_se)

