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
- **Operationalization**: Star power was operationalized as the average per-film earnings of the four main actors, while genre familiarity was quantified using the relative frequency of genres across films.
  
---

## Model

ln(OpeningRevenueᵢ) = β₀ + β₁·ln(StarPowerᵢ) + β₂·GenreFamiliarityᵢ
                    + β₃·(ln(StarPowerᵢ) × GenreFamiliarityᵢ)
                    + β₄·ln(ProductionBudgetᵢ)
                    + β₅·CriticRatingsᵢ + εᵢ

---

## Findings

###  Regression Estimates of Log Opening Weekend Revenue

| Variable              | Model 1                 | Model 2                 | Model 3                 | Model 4                 |
| --------------------- | ----------------------- | ----------------------- | ----------------------- | ----------------------- |
| **Intercept**         | 15.741\*\*\*<br>(0.033) | 15.580\*\*\*<br>(0.059) | 15.747\*\*\*<br>(0.033) | 15.737\*\*\*<br>(0.033) |
| **Log Star Power**    | 0.231\*\*\*<br>(0.039)  | 0.198\*\*\*<br>(0.039)  | 0.188\*\*\*<br>(0.043)  | 0.221\*\*\*<br>(0.037)  |
| **Genre Familiarity** | 0.033<br>(0.035)        | 0.048<br>(0.035)        | 0.023<br>(0.035)        | 0.041<br>(0.034)        |
| **Interaction**       | -0.075\*<br>(0.029)     | -0.063\*<br>(0.029)     | -0.068.<br>(0.038)      | -0.083\*\*<br>(0.028)   |
| **Log Budget**        | 1.091\*\*\*<br>(0.053)  | 1.098\*\*\*<br>(0.054)  | 1.128\*\*\*<br>(0.053)  | 1.132\*\*\*<br>(0.048)  |
| **Critic Ratings**    | -0.252\*\*\*<br>(0.032) | -0.264\*\*\*<br>(0.032) | -0.229\*\*\*<br>(0.032) | -0.246\*\*\*<br>(0.032) |
| **Late 2000s**        |                         | -0.061<br>(0.091)       |                         |                         |
| **Early 2010s**       |                         | 0.193\*<br>(0.089)      |                         |                         |
| **Late 2010s**        |                         | 0.616\*\*\*<br>(0.086)  |                         |                         |
| **Observations**      | 2,472                   | 2,458                   | 2,472                   | 2,469                   |
| **R²**                | 0.374                   | 0.390                   | 0.370                   | 0.382                   |
| **Adjusted R²**       | 0.373                   | 0.388                   | 0.369                   | 0.380                   |
| **F-statistic**       | 295.0\*\*\*             | 195.9\*\*\*             | 290.0\*\*\*             | 303.8\*\*\*             |

> Note: Robust standard errors in parentheses.  
> Significance levels: *** p < 0.001, ** p < 0.01, * p < 0.05, . p < 0.1  
> Model 2 includes 5-year period dummies (reference: early 2000s).


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
