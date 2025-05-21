DATA = ../data
TEMP = ../gen/temp
OUTPUT = ../gen/output

all: directories $(OUTPUT)/df_model.csv analysis robustness_year robustness_lead robustness_outliers

directories:
	@if not exist "$(subst /,\,$(TEMP))" mkdir "$(subst /,\,$(TEMP))"
	@if not exist "$(subst /,\,$(OUTPUT))" mkdir "$(subst /,\,$(OUTPUT))"

$(TEMP)/df_no_duplicates.csv: $(DATA)/df_raw.csv 01_preprocess.R | directories
	Rscript 01_preprocess.R

$(TEMP)/df_transformed.csv: $(TEMP)/df_no_duplicates.csv 02_feature_engineering.R | directories
	Rscript 02_feature_engineering.R

$(OUTPUT)/df_model.csv: $(TEMP)/df_transformed.csv 03_modeling.R | directories
	Rscript 03_modeling.R

analysis: $(OUTPUT)/df_model.csv 04_analysis.R
	Rscript 04_analysis.R

robustness_year: $(OUTPUT)/df_model.csv 05_robustness_movie_year.R
	Rscript 05_robustness_movie_year.R

robustness_lead: $(OUTPUT)/df_model.csv 06_robustness_lead_actor.R
	Rscript 06_robustness_lead_actor.R

robustness_outliers: $(OUTPUT)/df_model.csv 07_robustness_outliers_removed.R
	Rscript 07_robustness_outliers_removed.R

clean:
	Rscript -e "unlink('../gen', recursive = TRUE)"

.PHONY: all analysis robustness_year robustness_lead robustness_outliers clean directories