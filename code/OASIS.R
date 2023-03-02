# -- ------------------------------------------------------------------
#   -- Title: Oxford Acute Severity of Illness Score (oasis)
# -- This query extracts the Oxford acute severity of illness score.
# -- This score is a measure of severity of illness for patients in the ICU.
# -- The score is calculated on the first day of each ICU patients' stay.
# -- ------------------------------------------------------------------
# 
# -- Reference for OASIS:
# --    Johnson, Alistair EW, Andrew A. Kramer, and Gari D. Clifford.
# --    "A new severity of illness scale using a subset of acute physiology and chronic health evaluation data elements shows comparable predictive accuracy*."
# --    Critical care medicine 41, no. 7 (2013): 1711-1718.
# 
# -- Variables used in OASIS:
# --  Heart rate, GCS, MAP, Temperature, Respiratory rate, Ventilation status (sourced FROM `physionet-data.mimic_icu.chartevents`)
# --  Urine output (sourced from OUTPUTEVENTS)
# --  Elective surgery (sourced FROM `physionet-data.mimic_core.admissions` and SERVICES)
# --  Pre-ICU in-hospital length of stay (sourced FROM `physionet-data.mimic_core.admissions` and ICUSTAYS)
# --  Age (sourced FROM `physionet-data.mimic_core.patients`)
# 
# -- Regarding missing values:
# --  The ventilation flag is always 0/1. It cannot be missing, since VENT=0 if no data is found for vent settings.
# 
# -- Note:
# --  The score is calculated for *all* ICU patients, with the assumption that the user will subselect appropriate stay_ids.
# --  For example, the score is calculated for neonates, but it is likely inappropriate to actually use the score values for these patients.

# https://kuduz.tistory.com/1201
# install.packages("lubridate")
library(lubridate)
library(data.table)

icustays <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "icustays"))
services <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "services"))


icustays

surgical <- services %>%  
  mutate(surgflag = ifelse(curr_service %LIKE% "%SURG%" | curr_service %LIKE% "ORTHO", 1, 0))
# write.csv(surgical,"C:/Users/Repository/mimicr4_R/output/surgical.csv")

icustays %>% left_join(services, by = c("subject_id", "hadm_id")) %>% filter(transfertime < intime + days(1)) %>% group_by(stay_id)
    

##-------------------------- first day ventilation                
                       