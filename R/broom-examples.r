library(tidyverse)
library(broom)

nlsy_cols <- c("glasses", "eyesight", "sleep_wkdy", "sleep_wknd",
							 "id", "nsibs", "samp", "race_eth", "sex", "region",
							 "income", "res_1980", "res_2002", "age_bir")
nlsy <- read_csv(here::here("data", "nlsy.csv"),
								 na = c("-1", "-2", "-3", "-4", "-5", "-998"),
								 skip = 1, col_names = nlsy_cols) |>
	mutate(region_cat = factor(region, labels = c("Northeast", "North Central", "South", "West")),
				 sex_cat = factor(sex, labels = c("Male", "Female")),
				 race_eth_cat = factor(race_eth, labels = c("Hispanic", "Black", "Non-Black, Non-Hispanic")),
				 eyesight_cat = factor(eyesight, labels = c("Excellent", "Very good", "Good", "Fair", "Poor")))
#start here
nlsy_cols <- c("glasses", "eyesight", "sleep_wkdy", "sleep_wknd",
							 "id", "nsibs", "samp", "race_eth", "sex", "region",
							 "income", "res_1980", "res_2002", "age_bir")
nlsy <- read_csv(here::here("data", "raw", "nlsy.csv"),
								 na = c("-1", "-2", "-3", "-4", "-5", "-998"),
								 skip = 1, col_names = nlsy_cols) |>
	mutate(region_cat = factor(region, labels = c("Northeast", "North Central", "South", "West")),
				 sex_cat = factor(sex, labels = c("Male", "Female")),
				 race_eth_cat = factor(race_eth, labels = c("Hispanic", "Black", "Non-Black, Non-Hispanic")),
				 eyesight_cat = factor(eyesight, labels = c("Excellent", "Very good", "Good", "Fair", "Poor")),
				 glasses_cat = factor(glasses, labels = c("No", "Yes")))

mod_sex_cat <- lm(income ~ sex_cat, data = nlsy)
mod_race_eth_cat <- lm(income ~ race_eth_cat, data = nlsy)
mod_eyesight_cat <- lm(income ~ eyesight_cat, data = nlsy)
mod_age_bir <- lm(income ~ age_bir, data = nlsy)

tidy_sex_cat <- tidy(mod_sex_cat, conf.int = TRUE)
tidy_race_eth_cat <- tidy(mod_race_eth_cat, conf.int = TRUE)
tidy_eyesight_cat <- tidy(mod_eyesight_cat, conf.int = TRUE)
tidy_age_bir <- tidy(mod_age_bir, conf.int = TRUE)

bind_rows(
	sex_cat = tidy_sex_cat,
	race_eth_cat = tidy_race_eth_cat,
	eyesight_cat = tidy_eyesight_cat,
	age_bir = tidy_age_bir, .id = "model") |>
	mutate(
		term = str_remove(term, model),
		term = ifelse(term == "", model, term))

tidy(logistic_model, conf.int = TRUE, exponentiate = TRUE) |>
	tidycat::tidy_categorical(logistic_model, exponentiate = TRUE) |>
	select(-c(3:5))

tidy(logistic_model, conf.int = TRUE, exponentiate = TRUE) |>
	tidycat::tidy_categorical(logistic_model, exponentiate = TRUE) |>
	slice(-1) |> # remove intercept
	ggplot(mapping = aes(x = level, y = estimate,
											 ymin = conf.low, ymax = conf.high)) +
	geom_point() +
	geom_errorbar() +
	facet_grid(cols = vars(variable), scales = "free", space = "free") +
	scale_y_log10()
library(lmtest)
install.packages("sandwich")

library(sandwich)
#sex_cat
model1_robust <- coeftest(mod_sex_cat,
													vcov = vcovHC)
model1_robust_stata <- coeftest(mod_sex_cat,
																vcov = vcovHC,
																type = "HC1")
broom::tidy(model1_robust)
broom::tidy(model1_robust_stata)

#eth_


