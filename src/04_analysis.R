# --- Setup ---
# Load the necessary packages
library(tidyverse)
library(ggcorrplot)
library(moments)
library(car)
library(lmtest)
library(sandwich)
library(MASS)
library(boot)
library(modelr)
library(dplyr)
library(purrr)


# --- Input ---
df <- read.csv("../gen/output/df_model.csv", stringsAsFactors = FALSE)


# --- Summary statistics ---
summary(df)

# Compute standard deviation for key numerical variables
sd_values <- sapply(df[, c("opening_weekend", "production_budget", 
                           "star_power", "genre_familiarity", "tomatoMeter")], sd, na.rm = TRUE)

# Print the standard deviation values
print(sd_values)


# --- Skewness values ---
skewness(df$genre_familiarity, na.rm = TRUE)
skewness(df$tomatoMeter, na.rm = TRUE)
skewness(df$production_budget, na.rm = TRUE)
skewness(df$opening_weekend, na.rm = TRUE)
skewness(df$star_power,na.rm=TRUE)


# --- Correlation Analysis ---

# Select relevant numerical variables
cor_vars <- df %>%
  dplyr::select(log_opening_weekend, z_log_star_power, z_genre_familiarity, 
         z_log_production_budget, z_tomatoMeter)

# Compute the correlation matrix
cor_matrix <- cor(cor_vars, use = "complete.obs", method = "pearson")

# Print the correlation matrix
print(cor_matrix)


# --- Multicollinearity Check ---
model_1 <- lm(log_opening_weekend ~ z_log_star_power + z_genre_familiarity +
                interaction_z + z_log_production_budget + z_tomatoMeter, data = df)
summary(model_1)

vif(model_1)


# --- Robust Standard Errors ---
robust_se <- coeftest(model_1, vcov = vcovHC(model_1, type = "HC3"))
print(robust_se)


# --- Interaction Plot: Star Power × Genre Familiarity ---

# Create a sequence of star power values
star_seq <- seq(from = -2.5, to = 2.5, length.out = 100)


# Define low and high genre familiarity values
low_genre  <- -1
high_genre <- 1

# Create prediction data
predict_df <- bind_rows(
  data.frame(z_log_star_power = star_seq,
             z_genre_familiarity = low_genre,
             interaction_z = star_seq * low_genre,
             z_log_production_budget = mean(df$z_log_production_budget, na.rm = TRUE),
             z_tomatoMeter = mean(df$z_tomatoMeter, na.rm = TRUE)),
  
  data.frame(z_log_star_power = star_seq,
             z_genre_familiarity = high_genre,
             interaction_z = star_seq * high_genre,
             z_log_production_budget = mean(df$z_log_production_budget, na.rm = TRUE),
             z_tomatoMeter = mean(df$z_tomatoMeter, na.rm = TRUE))
)

# Predict using model_1
predict_df$log_opening_weekend <- predict(model_1, newdata = predict_df)

# Add label for plot
predict_df$Genre <- rep(c("Low Genre Familiarity", "High Genre Familiarity"), each = length(star_seq))

# Plot
star_power_plot <-ggplot(predict_df, aes(x = z_log_star_power, y = log_opening_weekend, color = Genre)) +
  geom_line(size = 1.2) +
  labs(
    x = "Standardized Star Power",
    y = "Predicted Log Opening Weekend Revenue",
    color = "Genre Familiarity"
  ) +
  scale_color_manual(values = c("High Genre Familiarity" = "#D55E00", "Low Genre Familiarity" = "#0072B2")) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "right",
    legend.title = element_text(face = "bold"),
    axis.title = element_text(face = "bold"),
    legend.text = element_text(size = 13)
  )

# Save the plot
ggsave("../gen/output/star_power_interaction_plot.png", plot = star_power_plot, width = 8, height = 6, dpi = 300)



# --- Box–Cox Transformation Test ---

# Fit the model using the original (untransformed) opening_weekend
bc <- df %>%
  dplyr::select(opening_weekend, z_log_star_power, z_genre_familiarity,
                interaction_z, z_log_production_budget, z_tomatoMeter)

bc_model <- lm(opening_weekend ~ ., data = bc)

png(filename = "../gen/output/boxcox_plot.png", width = 800, height = 600)


# Run the Box–Cox transformation test
boxcox_out <- boxcox(bc_model, lambda = seq(-1, 2, 0.1))

# Close device
dev.off()

# Optimal lambda 
lambda_best <- boxcox_out$x[which.max(boxcox_out$y)]
cat("Optimal lambda:", lambda_best, "\n")


# --- Heteroskedasticity Test ---

bp_test <- bptest(model_1)
print(bp_test)


# --- Normality Tests ---
residuals_model <- residuals(model_1)

# Shapiro-Wilk
shapiro.test(residuals_model)


# --- Residuals vs. Fitted Plot: Original (Untransformed) Model ---
model_untransformed <- lm(opening_weekend ~ z_log_star_power + z_genre_familiarity +
                            interaction_z + z_log_production_budget + z_tomatoMeter,
                          data = df)

df$resid_untrans <- resid(model_untransformed)
df$fitted_untrans <- fitted(model_untransformed)

# Plot of heteroskedasticity before log transformation
plot_untrans <- ggplot(df, aes(x = fitted_untrans, y = resid_untrans)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  labs(
    title = "Residuals vs. Fitted",
    x = "Fitted Values",
    y = "Residuals"
  ) +
  theme_minimal()

# Save the plot
ggsave("../gen/output/resid_vs_fitted_untrans.png", plot = plot_untrans, width = 8, height = 6, dpi = 300)


# --- Residuals vs. Fitted Plot: Log-Transformed Model ---
df$resid_log <- residuals_model
df$fitted_log <- fitted(model_1)

# Plot of heteroskedasticity after log transformation
plot_log <- ggplot(df, aes(x = fitted_log, y = resid_log)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  labs(
    title = "Residuals vs. Fitted (Log-Transformed DV)",
    x = "Fitted Values",
    y = "Residuals"
  ) +
  theme_minimal()

# Save the plot
ggsave("../gen/output/resid_vs_fitted_log.png", plot = plot_log, width = 8, height = 6, dpi = 300)


# --- Generalizability Check: Train-Test Split ---

set.seed(123)  
n <- nrow(df)
train_index <- sample(seq_len(n), size = 0.7 * n)

train_df <- df[train_index, ]
test_df  <- df[-train_index, ]

# Fit the model on the training data
model_train <- lm(log_opening_weekend ~ z_log_star_power + z_genre_familiarity +
                    interaction_z + z_log_production_budget + z_tomatoMeter,
                  data = train_df)


# Predict on the test data
test_df$predicted <- predict(model_train, newdata = test_df)


# Compute Out-of-Sample R²
rss <- sum((test_df$log_opening_weekend - test_df$predicted)^2)
tss <- sum((test_df$log_opening_weekend - mean(test_df$log_opening_weekend))^2)
r2_out_of_sample <- 1 - rss/tss
cat("Out-of-Sample R²:", round(r2_out_of_sample, 4), "\n")


# In-sample R² (Training set)
train_df$predicted_train <- predict(model_train, newdata = train_df)
rss_train <- sum((train_df$log_opening_weekend - train_df$predicted_train)^2)
tss_train <- sum((train_df$log_opening_weekend - mean(train_df$log_opening_weekend))^2)
r2_in_sample <- 1 - rss_train / tss_train
cat("In-sample R²:", round(r2_in_sample, 4), "\n")


# In-sample RMSE
rmse_in_sample <- sqrt(mean((train_df$log_opening_weekend - train_df$predicted_train)^2))
cat("In-sample RMSE:", round(rmse_in_sample, 4), "\n")


# --- 5-Fold Cross-Validation ---
set.seed(123)
cv_df <- crossv_kfold(df, k = 5) %>%
  mutate(
    train = map(train, as.data.frame),
    test  = map(test, as.data.frame),
    model = map(train, ~ lm(log_opening_weekend ~ z_log_star_power + 
                              z_genre_familiarity + interaction_z + 
                              z_log_production_budget + z_tomatoMeter, data = .x)),
    rmse = map2_dbl(model, test, ~ rmse(model = .x, data = .y)),
    rsq = map2_dbl(model, test, ~ {
      pred <- predict(.x, newdata = .y)
      actual <- .y$log_opening_weekend
      ss_res <- sum((actual - pred)^2)
      ss_tot <- sum((actual - mean(actual))^2)
      1 - (ss_res / ss_tot)
    })
  )

# Check ranges

range(cv_df$rmse)
range(cv_df$rsq)


# --- Plot RMSE ---
cv_plot <- ggplot(cv_df, aes(x = seq_along(rmse), y = rmse)) +
  geom_point(size = 2) +
  geom_line(group = 1, linetype = "dashed", color = "gray") +
  geom_hline(yintercept = mean(cv_df$rmse), color = "blue", linetype = "dotted", linewidth = 1) +
  labs(
    title = "RMSE Across 5 Folds (5-Fold Cross-Validation)",
    x = "Fold Number",
    y = "RMSE",
    caption = paste("Average RMSE =", round(mean(cv_df$rmse), 3))
  ) +
  theme_minimal(base_size = 13)


#Save the plot
ggsave("../gen/output/rmse_cv_plot.png", plot = cv_plot, width = 8, height = 6, dpi = 300)


# --- Plot R² ---
r2_plot_df <- data.frame(Fold = 1:5, R_squared = cv_df$rsq)

r2_plot <- ggplot(r2_plot_df, aes(x = Fold, y = R_squared)) +
  geom_line(color = "darkgreen", linetype = "dashed") +
  geom_point(size = 3, color = "darkgreen") +
  geom_hline(yintercept = mean(cv_df$rsq, na.rm = TRUE), linetype = "dotted", color = "blue") +
  annotate("text", x = 5, y = mean(cv_df$rsq, na.rm = TRUE) + 0.01,
           label = paste("Avg R² =", round(mean(cv_df$rsq, na.rm = TRUE), 3)),
           color = "blue", hjust = 1) +
  labs(
    title = "R² Across 5 Folds (5-Fold Cross-Validation)",
    x = "Fold Number",
    y = "R²"
  ) +
  theme_minimal(base_size = 13)

print(r2_plot)
ggsave("../gen/output/r2_cv_plot.png", plot = r2_plot, width = 8, height = 6, dpi = 300)