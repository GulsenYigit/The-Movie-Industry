# --- Setup ---
# Load the packages
library(tidyverse)
library(car)
library(sandwich)
library(lmtest)

# --- Input ---
df <- read.csv("../gen/output/df_model.csv", stringsAsFactors = FALSE)

# Fit main model on full data 
model_full <- lm(log_opening_weekend ~ z_log_star_power + z_genre_familiarity +
                   interaction_z + z_log_production_budget + z_tomatoMeter,
                 data = df)

summary(model_full)

# Identify influential points using Cook's Distance
cooks_d <- cooks.distance(model_full)
top_3_indices <- order(cooks_d, decreasing = TRUE)[1:3]
cat("Top 3 most influential indices:", top_3_indices, "\n")

# --- Save influence plot ---

# Save Influence Plot to gen/output
png(filename = "../gen/output/influence_plot.png", width = 800, height = 600)
influencePlot(model_full, main="Influence Plot")

dev.off()

# Remove the most influential points
df_no_influential <- df[-top_3_indices, ]

#  Refit model without top 3 influential points 
model_4 <- lm(log_opening_weekend ~ z_log_star_power + z_genre_familiarity +
                     interaction_z + z_log_production_budget + z_tomatoMeter,
                   data = df_no_influential)

# Summary of the model
summary(model_4)


# Calculate robust standard errors
robust_se <- coeftest(model_4, vcov = vcovHC(model_4, type = "HC3"))

# Print results
print(robust_se)