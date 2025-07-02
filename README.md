# Genre Familiarity and Star Power as Substitute Signals in the U.S. Movie Industry

This project explores the moderating effect of genre familiarity on the impact of star power in the U.S. movie industry. These variables could act as substitute signals in consumer decision-making. For example, familiar genres may offer audiences enough predictability that the need for star power is reduced. 

---

## Problem Introduction

Since movies are experience goods, consumers face information asymmetry because they have limited access to quality information before they watch the movie. To minimize uncertainty, consumers rely on quality signals. In this context, star power and genre familiarity can act as substitute signals. Familiar genres reduce uncertainty by helping audiences to predict a film’s quality and content better. As a result, consumers may rely less on external signals like star power. In less familiar genres, star power compensates for uncertainty. Based on the actor’s reputation or prior performances, the audience may infer that the film has high quality. This reduces the perceived risk of making a bad purchase decision.

---

## Research Question

**"How does genre familiarity moderate the impact of star power on the opening revenue of films in the U.S. movie industry?"**

---

## Methodology
- **Data sources**: Kaggle, Box Office Mojo, The-Numbers, Rotten Tomatoes.
- **Data collection**: Web scraping and Kaggle downloads.
- **Sample**: 2468 movies released between 2000 and 2020.
- **Model**: Log-linear regression with standardized predictors.
  
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

## Summary of Key Findings

| **Hypothesis** | **Finding** | **Significance** |
|----------------|-------------|------------------|
| H1: Star power has a positive effect on opening weekend revenue in the U.S. movie industry. | Supported | p < 0.001 |
| H2: The positive effect of star power on opening weekend revenue in the U.S. movie industry is weakened when genre familiarity increases. | Supported | p = 0.012 |

---

## Implications

- First, the findings suggest that the impact of star power is context-dependent. Although studios have often relied on popular actors to draw viewers, this study shows that the reliance on star power varies by genre familiarity. The impact of star power on opening weekend revenue is more substantial in unfamiliar genres, where consumers face greater uncertainty. In familiar genres, audiences are more confident in their expectations. As a result, the added value of star power diminishes. 
- For managers, there is greater flexibility in hiring less expensive actors for familiar genres. Instead, managers can invest more in marketing or production. On the other hand, for less familiar genres, it is advisable to feature well-known actors who can signal quality and reduce perceived audience risk. 
- The robustness checks reveal that the production budget is consistently the strongest predictor of opening weekend revenue. The production budget significantly outperforms star power in explaining early box office performance. Therefore, it is important for managers to prioritize investment in the production of movies, as it is the most reliable driver of early box office success.
- Lastly, the findings carry marketing implications. Traditionally, movie promotions emphasize star power. However, the interaction effect between star power and genre familiarity indicates that for movies in familiar genres, marketing efforts may be more effective when they focus on genre cues. In contrast, for movies in unfamiliar genres, marketing should emphasize star presence to reduce audience uncertainty.

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
