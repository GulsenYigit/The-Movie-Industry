# Genre Familiarity and Star Power as Substitute Signals in the U.S. Movie Industry

This project explores the moderating effect of genre familiarity on the impact of star power in the U.S. movie industry. These variables could act as substitute signals in consumer decision-making. For example, familiar genres may offer audiences enough predictability that the need for star power is reduced. 

---

## Research Question

**"How does genre familiarity moderate the impact of star power on the opening revenue of films in the U.S. movie industry?"**

---

## Methodology
- **Data sources**: Kaggle, Box Office Mojo, The-Numbers, Rotten Tomatoes
- **Data collection**: Web scraping and Kaggle downloads
- **Sample**: 2468 movies released between 2000 and 2020
- **Model**: Log-linear regression with standardized predictors
  
---

## Model

ln(OpeningRevenueᵢ) = β₀ + β₁·ln(StarPowerᵢ) + β₂·GenreFamiliarityᵢ
                    + β₃·(ln(StarPowerᵢ) × GenreFamiliarityᵢ)
                    + β₄·ln(ProductionBudgetᵢ)
                    + β₅·CriticRatingsᵢ + εᵢ

---

## Findings

- The strongest and most significant predictor in the model is the log-transformed, standardized production budget. A 1% increase in the standardized production budget is associated with a 1.091% increase in opening weekend revenue (p-value < 2.2e-16), holding other factors constant.
- Log-transformed, standardized star power is also a strong predictor of opening weekend revenue. A 1% increase in standardized star power leads to a 0.231% increase in opening weekend revenue (p-value = 3.79e-09), holding other factors constant.
- Standardized genre familiarity shows a positive but statistically insignificant effect. A one-standardized unit increase in genre familiarity leads to a 3.3% increase in opening revenue (p-value = 0.340), holding other factors constant.
- A one-standardized unit increase in critic ratings is associated with a 25.2% decrease in opening weekend revenue (p-value = 8.75e-15), holding other factors constant.
- The interaction effect between star power and genre familiarity is negative and statistically significant. For each one-standardized unit increase in genre familiarity, the positive effect of star power on opening revenue decreases by approximately 0.075% (p-value = 0.012). This implies that the two variables act as substitute signals.

---

### Summary of Key Findings

| **Hypothesis** | **Finding** | **Significance** |
|----------------|-------------|------------------|
| H1: Star power has a positive effect on opening weekend revenue in the U.S. movie industry. | Supported | p < 0.001 |
| H2: The positive effect of star power on opening weekend revenue in the U.S. movie industry is weakened when genre familiarity increases. | Supported | p = 0.012 |

---

## Folder Structure

```plaintext
The-Movie-Industry/
├── data/                          # Raw input data (ignored by Git)
├── gen/
│   ├── output/                    # Final plots and regression results
│   └── temp/                      # Temporary files (ignored by Git)
├── src/                           # R scripts and Makefile
│   ├── Makefile                   # Reproducible workflow
│   ├── 01_preprocess.R
│   ├── 02_feature_engineering.R
│   ├── 03_modeling.R
│   ├── 04_analysis.R
│   ├── 05_robustness_movie_year.R
│   ├── 06_robustness_lead_actor.R
│   └── 07_robustness_outliers_removed.R  
├── .gitignore
└── README.md

```
