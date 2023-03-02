
#feature exploration
#potential Variables
#나이, 성별, 입원관련 기본정보는 subject 에서 구성가능
# apache score, DMSS,
# surgery , type of anesthesia (General/Spinal or Epidural)
# Fall-down risk High/low
# CAM-ICU #https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6513664/
# BMI
# 인공호흡기 종류 (기계적/자발적)
# 동반질환
# LAB (BUN, Creatinine, BUN/Cr ratio, eGFR, Hb, Hct, WBC, CRP, ESR, Total protein, albumin, prothrombin time, ALP, AST, ALT, total bilirubin, total cholesterol, sodium, potassium)
# Urine panel()
# clinical note는 따로 있음

chartevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "chartevents"))
labevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "labevents"))
d_hcpcs <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "d_hcpcs"))
d_icd_diagnoses <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "d_icd_diagnoses"))
d_icd_procedures <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "d_icd_procedures"))
d_labitems <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "d_labitems"))
d_items <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "d_items"))


# d_hcpcs <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "d_hcpcs"))
# d_icd_diagnoses <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "d_icd_diagnoses"))
# d_icd_procedures <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "d_icd_procedures"))
# d_labitems <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "d_labitems"))
# diagnoses_icd <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "diagnoses_icd"))
# drgcodes <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "drgcodes"))
# emar <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "emar"))
# emar_detail <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "emar_detail"))
# hcpcsevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "hcpcsevents"))
# labevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "labevents"))
# microbiologyevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "microbiologyevents"))
# pharmacy <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "pharmacy"))
# poe <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "poe"))
# poe_detail <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "poe_detail"))
# prescriptions <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "prescriptions"))
# procedures_icd <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "procedures_icd"))
# services <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "services"))
# chartevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "chartevents"))
# d_items <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "d_items"))
# datetimeevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "datetimeevents"))
# icustays <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "icustays"))
# inputevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "inputevents"))
# outputevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "outputevents"))
# procedureevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "procedureevents"))


d_icd_procedures %>% filter((long_title %LIKE% "%nesthe%")) ## 이걸로 전신마취 여부 확인할 수 있음 
##수술명도 icd가 있는데, 정확한 수술명을 알아야 함... 모든 수술 이런거 없음...

emar <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "emar"))
emar_detail <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "emar_detail"))
emar

poe <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "poe"))
poe_detail <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "poe_detail"))

poe %>% view()

procedures_icd <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "procedures_icd"))
procedures_icd

d_icd_diagnoses

procedureevents <- dplyr::tbl(conn, dbplyr::in_schema("mimic_icu", "procedureevents"))
procedureevents %>% view()


d_icd_procedures

##surgery

d_icd_procedures %>% filter(long_title %LIKE% "%urgery%") %>% count(icd_code) %>% print(n=100)

##ventilation

d_icd_procedures %>% filter(long_title %LIKE% "%entil%") %>% count(icd_code) %>% print(n=100)

# ICD9
#Non-invasive mechanical ventilation 9390  
# 9670  Continuous invasive mechanical ventilation of unspecified duration
# 9671  Continuous invasive mechanical ventilation for less than 96 consecutive hours
# 9672  Continuous invasive mechanical ventilation for 96 consecutive

# ICD10 (많다...)
# 5A09357
# 5A09358


## BUN
d_labitems %>% filter(label %LIKE% "%itrogen%" & fluid == "Blood")   #item search ( %>%  view)
bun_itemid <- c(51006, 52657)

## Creatinine
d_labitems %>% filter(label %LIKE% "%reatinin%" & fluid == "Blood" & category =="Chemistry")
creatinine_itemid <- c(50912,52546)

## BUN/Cr ratio
## 이건 BUN/CR 구해서 추후 테이블에서 계산

## CrCl
d_labitems %>% filter(label %LIKE% "%Creatinine Clear%")
crcl_itemid <- c(51080)

## eGFR (estimated Glomerular filtration rate) == CrCl
d_labitems %>% filter(label %LIKE% "%lomeru%")
## 결과 없음

## Hb (hemoglobin)
d_labitems %>% filter(label %LIKE% "%globin%" & fluid =="Blood"&category=="Hematology")
hb_itemid <- c(51222)

## Hct (hematocrit)
d_labitems %>% filter(label %LIKE% "%matocrit%" & fluid =="Blood"&category=="Hematology")
hct_itemid <- c(51221)

## WBC(white blood cell)
d_labitems %>% filter(label %LIKE% "%White Blood%" &category == "Hematology")
wbc_itemid <- c(51301)

##CRP
d_labitems %>% filter(label %LIKE% "%eactive %")
crp_itemid <- c(50889)

## ESR(erythrocyte sedimentation rate)
d_labitems %>% filter(label %LIKE% "%edimentati%" & fluid =="Blood")
esr_itemid <- c(51288)

## Total Protein
d_labitems %>% filter(label %LIKE% "%rotein%" & fluid =="Blood" & category =="Chemistry")
tpro_itemid <- c(50976)

## Albumin
d_labitems %>% filter(label %LIKE% "%lbumin%" & fluid =="Blood")
albu_itemid <- c(51542, 50862) ##50862만 해당될 수 있음?

##PT, prothrombin time
d_labitems %>% filter(label %LIKE% "%PT%")
#INR(PT) : 51237
#PT : 51274,52921
#PTT : 51275, 52923
pt_itemid <- c(51274,52921)
ptt_itemid <- c(51275,52923)

##ALP(alkaline phosphatase)/ALT(alanine transaminase)/AST(asparate aminotransferase)/GGT(gamma-glutamyl transferase)
d_labitems %>% filter(label %LIKE% "%lkalin%")
alp_itemid <- c(50863)

d_labitems %>% filter(label %LIKE% "%lanin%")
alt_itemid <- c(50861)

d_labitems %>% filter(label %LIKE% "%spa%")
ast_itemid <- c(50878)

d_labitems %>% filter(label %LIKE% "%amma%")
ggt_itmeid <- c(50927)

##total bilirubin, 
d_labitems %>% filter(label %LIKE% "%ili%" & fluid =="Blood" & category =="Chemistry")
tbili_itemid <- c(50885)

##total cholesterol,
d_labitems %>% filter(label %LIKE% "%holester%" & fluid =="Blood" & category =="Chemistry")
tchol_itemid <- c(50907)

## sodium,
d_labitems %>% filter(label %LIKE% "%odium%")
sodium_itemid <- c(50983,52623)

## potassium
d_labitems %>% filter(label %LIKE% "%otassi%")
potassium_itemid <- c(50971,52610)


##-------------------------------------------------------------------------------------------------------------------
##bun
bun_tb1 <- labevents %>%  filter(itemid %in% bun_itemid) 
bun_tb2 <- bun_tb1 %>% 
  rename("bun" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "bun","valueuom","ref_range_lower","ref_range_upper","flag")
bun_tb2 %>% count(itemid) #각 아이템아이디 별로 몇개인지 확인하기
write.csv(bun_tb2,"C:/Users/Repository/mimicr4_R/output/bun.csv")

## Creatinine
creatinine_tb1 <- labevents %>%  filter(itemid %in% creatinine_itemid) 
creatinine_tb1
creatinine_tb2 <- creatinine_tb1 %>% 
  rename("creatinine" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "creatinine","valueuom","ref_range_lower","ref_range_upper","flag")
creatinine_tb2 %>% count(itemid) #각 아이템아이디 별로 몇개인지 확인하기
write.csv(creatinine_tb2,"C:/Users/Repository/mimicr4_R/output/creatinine.csv")

## BUN/Cr ratio
## 이건 BUN/CR 구해서 추후 테이블에서 계산

## CrCl (== eGFR)
crcl_tb1 <- labevents %>%  filter(itemid %in% crcl_itemid) 
crcl_tb1
crcl_tb2 <- crcl_tb1 %>% 
  rename("crcl" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "crcl","valueuom","ref_range_lower","ref_range_upper","flag")
crcl_tb2 %>% count(itemid) ##역시 케이스가 적군....따로 구해야 하나??
write.csv(crcl_tb2,"C:/Users/Repository/mimicr4_R/output/crcl.csv")

## Hb (hemoglobin)
hb_tb1 <- labevents %>%  filter(itemid %in% hb_itemid) 
hb_tb1
hb_tb2 <- hb_tb1 %>% 
  rename("hb" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "hb","valueuom","ref_range_lower","ref_range_upper","flag")
hb_tb2 %>% count(itemid) 
write.csv(hb_tb2,"C:/Users/Repository/mimicr4_R/output/hemoglobin.csv")

## Hct (hematocrit)
hct_tb1 <- labevents %>%  filter(itemid %in% hct_itemid) 
hct_tb1
hct_tb2 <- hct_tb1 %>% 
  rename("hct" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "hct","valueuom","ref_range_lower","ref_range_upper","flag")
hct_tb2 %>% count(itemid) 
write.csv(hct_tb2,"C:/Users/Repository/mimicr4_R/output/hematocrit.csv")

## WBC(white blood cell)
wbc_tb1 <- labevents %>%  filter(itemid %in% wbc_itemid) 
wbc_tb1
wbc_tb2 <- hct_tb1 %>% 
  rename("wbc" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "wbc","valueuom","ref_range_lower","ref_range_upper","flag")
wbc_tb2 %>% count(itemid) 
write.csv(wbc_tb2,"C:/Users/Repository/mimicr4_R/output/wbc.csv")

##CRP
crp_tb1 <- labevents %>%  filter(itemid %in% crp_itemid) 
crp_tb1
crp_tb2 <- crp_tb1 %>% 
  rename("crp" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "crp","valueuom","ref_range_lower","ref_range_upper","flag")
crp_tb2 %>% count(itemid)
write.csv(crp_tb2,"C:/Users/Repository/mimicr4_R/output/crp.csv")

## ESR(erythrocyte sedimentation rate)
esr_tb1 <- labevents %>%  filter(itemid %in% esr_itemid) 
esr_tb1
esr_tb2 <- esr_tb1 %>% 
  rename("esr" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "esr","valueuom","ref_range_lower","ref_range_upper","flag")
esr_tb2 %>% count(itemid)
write.csv(esr_tb2,"C:/Users/Repository/mimicr4_R/output/esr.csv")

## Total Protein
tpro_tb1 <- labevents %>%  filter(itemid %in% tpro_itemid) 
tpro_tb1
tpro_tb2 <- tpro_tb1 %>% 
  rename("tpro" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "tpro","valueuom","ref_range_lower","ref_range_upper","flag")
tpro_tb2 %>% count(itemid)
write.csv(tpro_tb2,"C:/Users/Repository/mimicr4_R/output/total_protein.csv")

## Albumin
albu_tb1 <- labevents %>%  filter(itemid %in% albu_itemid) 
albu_tb1
albu_tb2 <- albu_tb1 %>% 
  rename("albu" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "albu","valueuom","ref_range_lower","ref_range_upper","flag")
albu_tb2 %>% count(itemid)
write.csv(albu_tb2,"C:/Users/Repository/mimicr4_R/output/albumin.csv")

## PT
pt_tb1 <- labevents %>%  filter(itemid %in% pt_itemid) 
pt_tb1
pt_tb2 <- pt_tb1 %>% 
  rename("pt" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "pt","valueuom","ref_range_lower","ref_range_upper","flag")
pt_tb2 %>% count(itemid)
write.csv(pt_tb2,"C:/Users/Repository/mimicr4_R/output/pt.csv")

## PTT
ptt_tb1 <- labevents %>%  filter(itemid %in% ptt_itemid) 
ptt_tb1
ptt_tb2 <- ptt_tb1 %>% 
  rename("ptt" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "ptt","valueuom","ref_range_lower","ref_range_upper","flag")
ptt_tb2 %>% count(itemid)
write.csv(ptt_tb2,"C:/Users/Repository/mimicr4_R/output/ptt.csv")

## ALP(alkaline phosphatase)/
alp_tb1 <- labevents %>%  filter(itemid %in% alp_itemid) 
alp_tb1
alp_tb2 <- alp_tb1 %>% 
  rename("alp" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "alp","valueuom","ref_range_lower","ref_range_upper","flag")
alp_tb2 %>% count(itemid)
write.csv(alp_tb2,"C:/Users/Repository/mimicr4_R/output/alp.csv")

## ALT(alanine transaminase)/AST(asparate aminotransferase)/GGT(gamma-glutamyl transferase)
alt_tb1 <- labevents %>%  filter(itemid %in% alt_itemid) 
alt_tb1
alt_tb2 <- alt_tb1 %>% 
  rename("alt" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "alt","valueuom","ref_range_lower","ref_range_upper","flag")
alt_tb2 %>% count(itemid)
write.csv(alt_tb2,"C:/Users/Repository/mimicr4_R/output/alt.csv")

## AST(asparate aminotransferase)
ast_tb1 <- labevents %>%  filter(itemid %in% ast_itemid) 
ast_tb1
ast_tb2 <- ast_tb1 %>% 
  rename("ast" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "ast","valueuom","ref_range_lower","ref_range_upper","flag")
ast_tb2 %>% count(itemid)
write.csv(ast_tb2,"C:/Users/Repository/mimicr4_R/output/ast.csv")

## GGT(gamma-glutamyl transferase)
ggt_tb1 <- labevents %>%  filter(itemid %in% ggt_itemid) 
ggt_tb1
ggt_tb2 <- ggt_tb1 %>% 
  rename("ggt" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "ggt","valueuom","ref_range_lower","ref_range_upper","flag")
ggt_tb2 %>% count(itemid)
write.csv(ggt_tb2,"C:/Users/Repository/mimicr4_R/output/ggt.csv")

##total bilirubin, 
tbili_tb1 <- labevents %>%  filter(itemid %in% tbili_itemid) 
tbili_tb1
tbili_tb2 <- tbili_tb1 %>% 
  rename("tbili" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "tbili","valueuom","ref_range_lower","ref_range_upper","flag")
tbili_tb2 %>% count(itemid)
write.csv(tbili_tb2,"C:/Users/Repository/mimicr4_R/output/total_bilirubin.csv")

##total cholesterol,
tcol_tb1 <- labevents %>%  filter(itemid %in% tchol_itemid) 
tcol_tb1
tcol_tb2 <- tcol_tb1 %>% 
  rename("tcol" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "tcol","valueuom","ref_range_lower","ref_range_upper","flag")
tcol_tb2 %>% count(itemid)
write.csv(tcol_tb2,"C:/Users/Repository/mimicr4_R/output/total_cholesterol.csv")

## sodium
sodium_tb1 <- labevents %>%  filter(itemid %in% sodium_itemid) 
sodium_tb1
sodium_tb2 <- sodium_tb1 %>% 
  rename("sodium" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "sodium","valueuom","ref_range_lower","ref_range_upper","flag")
sodium_tb2 %>% count(itemid)
write.csv(sodium_tb2,"C:/Users/Repository/mimicr4_R/output/sodium.csv")

## potassium
potassium_tb1 <- labevents %>%  filter(itemid %in% potassium_itemid) 
potassium_tb1
potassium_tb2 <- potassium_tb1 %>% 
  rename("potassium" = "valuenum") %>% 
  select("subject_id","hadm_id","labevent_id","specimen_id","itemid","charttime", "potassium","valueuom","ref_range_lower","ref_range_upper","flag")
potassium_tb2 %>% count(itemid)
write.csv(potassium_tb2,"C:/Users/Repository/mimicr4_R/output/potassium.csv")































####---------------CAMICU----------------------------------------------------######
CAMICU_list <- d_items %>% filter(label %LIKE% "%CAM%")  #item search ( %>%  view)
camicu_labels<- CAMICU_list %>% select(itemid, label)
camicu_itemid <- c(228300, 228301, 228302, 228303, 228334, 229324, 229325, 229326,228335, 228336, 228337)

camicu1 <- chartevents %>%  filter(itemid %in% camicu_itemid) 
camicu2 <- camicu1 %>% left_join(camicu_labels, by = 'itemid') %>% 
  select("subject_id", "hadm_id", "stay_id", "charttime","storetime", "itemid", "label", "value","valuenum", "valueuom","warning")
camicu2 %>% count(itemid) #각 아이템아이디 별로 몇개인지 확인하기
#확인결과, 228303, 228334, 228336, 228337**, 229325 가 집계가 많았음


#camicu1<- CAMICU_list %>% filter(itemid %in% c(228303, 228334, 228336, 228337, 229325)) %>% left_join(cam1, by=itemid)
#camicu1
#228334 = Altered LOC : 변경된 의식수준 
#228303 Disorganized thinking : 와해된 사고
#228337 Mental state change -- 아마 이게 제일 중요할 텐데, 감별이 필요함
# https://uploads-ssl.webflow.com/5b0849daec50243a0a1e5e0c/5bb419ef096deffda9f9bef0_CAM_ICU_training_Korean.pdf
#RASS  평가 - 리치몬드 흥분/진정 단계 --> -4, -5면 검사 중지 Rass -3 이상이면 2단계 섬망상태 평가 시행함
#섬망상태 평가에 따르면... 특성 1 급성 정신상태 변화[Altered LOC] 또는 정신 상태 변동이 심함 => 특성2 주의력 결핍(Inattention) => 특성3 비체계적인사고(disorganized thinking) 또는 특성4 의식수준의 변화(mschange) ===> 면섬망으로 진단
#그럼 밑에 정보를 조합해서 섬망인지 아닌지 여부를 확인해야 하는가?

#각 itemid 탐색하기 
camicu2 %>%  filter(itemid == 228300) # MS change (mental state change) 여부- 사정할 수 없음, 없음, 있음 (진행), 멘탈 체크한 데이터로 보임
camicu2 %>%  filter(itemid == 228301) # 집중할 수 없음 (yes - 3 or more error), continue, less than 3 errors ... 
camicu2 %>%  filter(itemid == 228302) # yes or no
camicu2 %>%  filter(itemid == 228303) # yes or no
camicu2 %>%  filter(itemid == 228334) # 변경된 의식수준 ; 1, 0 yes or no
camicu2 %>%  filter(itemid == 228335) # 와해된 사고 : 없음, 사정할 수 없음, 있음 -- valuenum 있음
camicu2 %>%  filter(itemid == 228336) # 집중할 수 없음, 없음, 사정할 수 없음, 있음 value 있음 
camicu2 %>%  filter(itemid == 228337) # ms change 있음 없음 .. value 있음 
camicu2 %>%  filter(itemid == 229324) # 와해된 사고 있음 없음
camicu2 %>%  filter(itemid == 229325) # 집중 value 있음 

#그렇다면, RASS 는 1단계 평가라서 RASS 에서 이상이 있는 사람들이 2단계를 했을 것. 
# 2단계 평가는 특성별로 테이블을 구성해야 할듯
# 228302 : CAM-ICU RASS LOC
# 228334 : CAM-ICU Altered LOC
# 228300 : CAM-ICU MS change
# 228337 : CAM-ICU MS change
# 228301 : CAM-ICU Inattention
# 228336 : CAM-ICU Inattention
# 229325 : CAM-ICU Inattention
# 228303 : CAM-ICU Disorganized thinking
# 228335 : CAM-ICU Disorganized thinking
# 229324 : CAM-ICU Disorganized thinking

#%>% filter(!is.na(valuenum))

camicu_rass <- camicu2 %>%  filter(itemid == 228302) %>% 
  rename("rass_loc_v" = "value") %>% 
  select("subject_id","hadm_id","stay_id","charttime","itemid","rass_loc_v")

camicu_alteredloc <- camicu2 %>%  filter(itemid == 228334) %>% 
  rename("altered_loc_v"="value")%>% 
  select("subject_id","hadm_id","stay_id","charttime","itemid","altered_loc_v")

camicu_mschange <- camicu2 %>%  filter(itemid %in% c(228300,228337)) %>% 
  rename("ms_change_v" = "value") %>% 
  select("subject_id","hadm_id","stay_id","charttime","itemid","ms_change_v")

camicu_inattention <- camicu2 %>%  filter(itemid %in% c(228301,228336,229325)) %>% 
  rename("inattention_v" = "value") %>% 
  select("subject_id","hadm_id","stay_id","charttime","itemid","inattention_v")

camicu_disorgthink <- camicu2 %>%  filter(itemid %in% c(228303,228335,229324)) %>% 
  rename("disorgthink_v" = "value") %>% 
  select("subject_id","hadm_id","stay_id","charttime","itemid","disorgthink_v")

#---------------------------------------------------------------------------------
#value 에 문자열로 된 것들 숫자로 바꿔주기.

camicu_rass %>% count(rass_loc_v)
camicu_rass <- camicu_rass %>% mutate(rass_loc = ifelse(rass_loc_v == "Yes", 1, 0))
camicu_rass %>% count(rass_loc)

camicu_alteredloc %>% count(altered_loc_v)
camicu_alteredloc <- camicu_alteredloc %>% mutate(altered_loc = ifelse(altered_loc_v == "Yes", 1, 0))
camicu_alteredloc %>% count(altered_loc)

camicu_mschange %>% count(ms_change_v)
camicu_mschange <- camicu_mschange %>%  mutate(ms_change = ifelse(ms_change_v == "Yes",1, ifelse(ms_change_v =="Yes (Continue)", 1, 0)))
camicu_mschange %>%  count(ms_change)

camicu_inattention %>% count(inattention_v)
camicu_inattention <- camicu_inattention %>% mutate(inattention = ifelse(inattention_v == "Yes", 1, ifelse(inattention_v == "Yes (3 or more errors, then Continue)", 1, 0)))
camicu_inattention %>% count(inattention)

camicu_disorgthink %>%  count(disorgthink_v)
camicu_disorgthink <- camicu_disorgthink %>% mutate(disorgthink = ifelse(disorgthink_v == "Yes", 1, 0))
camicu_disorgthink %>% count(disorgthink)

#camicu_tb1 <- camicu_rass %>% full_join(camicu_alteredloc, by = c("subject_id","hadm_id","stay_id","charttime")) %>% 
#  mutate(itemid = ifelse(!is.na(itemid.x) & !is.na(itemid.y), itemid.x, ifelse(is.na(itemid.y), itemid.x, itemid.y)))

camicu_tb1 <- camicu_rass %>% full_join(camicu_alteredloc, by = c("subject_id","hadm_id","stay_id","charttime")) %>% 
  select("subject_id","hadm_id","stay_id","charttime","rass_loc","altered_loc") %>% 
  full_join(camicu_mschange, by = c("subject_id","hadm_id","stay_id","charttime")) %>% 
  select("subject_id","hadm_id","stay_id","charttime","rass_loc","altered_loc","ms_change") %>% 
  full_join(camicu_inattention, by = c("subject_id","hadm_id","stay_id","charttime")) %>% 
  select("subject_id","hadm_id","stay_id","charttime","rass_loc","altered_loc","ms_change","inattention") %>% 
  full_join(camicu_disorgthink, by = c("subject_id","hadm_id","stay_id","charttime")) %>% 
  select("subject_id","hadm_id","stay_id","charttime","rass_loc","altered_loc","inattention","disorgthink","ms_change")

camicu_tb1
write.csv(camicu_tb1,"C:/Users/Repository/mimicr4_R/output/camicu_tb1.csv")

#--------------------------------------------------------------------------------------------
#특성 1 급성 정신상태 변화[Altered LOC] 또는 정신 상태 변동이 심함
#=> 특성2 주의력 결핍(Inattention) 
#=>특성3 비체계적인사고(disorganized thinking) 또는 특성4 의식수준의 변화(mschange)
#===> 면섬망으로 진단
camicu_tb1 <- read.csv("C:/Users/Repository/mimicr4_R/output/camicu_tb1.csv")
camicu_tb1

camicu_tb2 <- camicu_tb1 %>% mutate(delirium_1 = ifelse(inattention == 1 & disorgthink ==1, 1, 0)) #특성2+특성3
camicu_tb2 <- camicu_tb2 %>% mutate(delirium_2 = ifelse(inattention == 1 & ms_change == 1, 1, 0)) #특성2+특성4
camicu_tb2 %>% view()
camicu_tb2

camicu_tb2 <- camicu_tb2 %>% mutate(delirium = ifelse(is.na(delirium_1) & is.na(delirium_2), 0, 
                                          ifelse(is.na(delirium_1) & delirium_2 == 1, 1,
                                                 ifelse(delirium_1 == 1 & is.na(delirium_2),1, 0))))

# camicu_tb2 %>% mutate(delirium = if_else(delirium_1 ==1 & delirium_2==1, 1, 
#                                                       if_else(delirium_1 == 1 & delirium_2 == 0, 1,
#                                                              if_else(delirium_1 == 0 & delirium_2 == 1, 1,
#                                                                      if_else(is.null(delirium_1) & delirium_2 ==1,1,
#                                                                              if_else(delirium_1 == 1 & is.null(delirium_2), 1, 0))))))

camicu_tb2 %>% view()


#이러면 delirium event는 모두 구할 수 있음
