# ------------------------------------------------------------------
#   -- This query extracts Charlson Comorbidity Index (CCI) based on the recorded ICD-9 and ICD-10 codes.
# --
#   -- Reference for CCI:
#   -- (1) Charlson ME, Pompei P, Ales KL, MacKenzie CR. (1987) A new method of classifying prognostic 
# -- comorbidity in longitudinal studies: development and validation.J Chronic Dis; 40(5):373-83.
# --
#   -- (2) Charlson M, Szatrowski TP, Peterson J, Gold J. (1994) Validation of a combined comorbidity 
# -- index. J Clin Epidemiol; 47(11):1245-51.
# -- 
#   -- Reference for ICD-9-CM and ICD-10 Coding Algorithms for Charlson Comorbidities:
#   -- (3) Quan H, Sundararajan V, Halfon P, et al. Coding algorithms for defining Comorbidities in ICD-9-CM
# -- and ICD-10 administrative data. Med Care. 2005 Nov; 43(11): 1130-9.
# -- ------------------------------------------------------------------
diagnoses_icd <- dplyr::tbl(conn, dbplyr::in_schema("mimic_hosp", "diagnoses_icd"))

diagnoses_icd %>% 
  mutate(diag) %>% select(hadm_id)


diag1 <- diagnoses_icd %>% 
  mutate(icd9_code = ifelse(icd_version == 9,icd_code, NULL)) %>% 
  mutate(icd10_code = ifelse(icd_version == 10, icd_code, NULL))


diag
#-- Myocardial infarction

diag %>% filter(substr(icd9_code, 1, 3) %in% c('410','412'))
diag %>% filter(substr(icd10_code, 1, 3) %in% c('I21','I22'))
diag %>% filter(substr(icd10_code, 1, 4) %in% c('I252'))

diag <- diag1 %>%
  mutate(myocardial_infarct = if_else(substr(icd9_code, 1, 3) %in% c('410','412')
                                      |substr(icd10_code, 1, 3) %in% c('I21','I22')
                                      |substr(icd10_code, 1, 4) %in% c('I252'), 1, 0)) %>% 
  mutate(congestive_heart_failure = if_else(substr(icd9_code, 1, 3) %in% c('428')
                                            |substr(icd9_code, 1, 5) %in% c('39891','40201','40211','40291','40401','40403',
                                                                            '40411','40413','40491','40493')
                                            |substr(icd9_code, 1, 4) %in% c('4254','4255','4256','4257','4258','4259')
                                            |substr(icd10_code, 1, 3) %in% c('I43','I50')
                                            |substr(icd10_code, 1, 4) %in% c('I099','I110','I130','I132','I255','I420','I425','I426',
                                                                             'I427','I428','I429','P290'), 1, 0)) %>% 
  mutate(peripheral_vascular_disease = if_else(substr(icd9_code, 1, 3) %in% c('440','441')
                                               |substr(icd9_code, 1, 4) %in% c('0930','4373','4471','5571','5579','v434')
                                               |substr(icd9_code, 1, 4) %in% c('4431','4432','4433','4434','4435','4436','4437','4438','4439')
                                               |substr(icd10_code, 1, 3) %in% c('I70','I71')
                                               |substr(icd10_code, 1, 4) %in% c('I731','I738','I739','I771','I790','I792','K551',
                                                                                'K558','K559','Z958','Z959'), 1, 0)) %>% 
  mutate(cerebrovascular_disease = if_else(substr(icd9_code, 1, 3) %in% c('430','438')
                                           |substr(icd9_code, 1, 5) %in% c('36234')
                                           |substr(icd10_code, 1, 3) %in% c('G45','G46')
                                           |substr(icd10_code, 1, 3) %in% c('I60','I69')
                                           |substr(icd10_code, 1, 4) %in% c('H340'), 1, 0)) %>% 
  mutate(dementia = if_else(substr(icd9_code, 1, 3) %in% c('290')
                            |substr(icd9_code, 1, 4) %in% c('2941','3312')
                            |substr(icd10_code, 1, 3) %in% c('F00','F01','F02','F03','G30')
                            |substr(icd10_code, 1, 4) %in% c('F051','G311'), 1, 0)) %>% 
  mutate(chronic_pulmonary_disease = if_else(substr(icd9_code, 1, 3) %in% c('490','505')
                                             |substr(icd9_code, 1, 4) %in% c('4168','4169','5064','5081','5088')
                                             |substr(icd10_code, 1, 3) %in% c('J40','J47')
                                             |substr(icd10_code, 1, 3) %in% c('J60','J67')
                                             |substr(icd10_code, 1, 4) %in% c('I278','I279','J684','J701','J703'), 1, 0)) %>% 
  mutate(rheumatic_disease = if_else(substr(icd9_code, 1, 3) %in% c('725')
                                     |substr(icd9_code, 1, 4) %in% c('4465','7100','7101','7102','7103','7104','7140','7141','7142','7148')
                                     |substr(icd10_code, 1, 3) %in% c('M05','M06','M32','M33','M34')
                                     |substr(icd10_code, 1, 4) %in% c('M315','M351','M353','M360'), 1, 0)) %>% 
  mutate(peptic_ulcer_disease = if_else(substr(icd9_code, 1, 3) %in% c('531','532','533','534')
                                        |substr(icd10_code, 1, 3) %in% c('K25','K26','K27','K28'), 1, 0)) %>% 
  mutate(mild_liver_disease = if_else(substr(icd9_code, 1, 3) %in% c('570','571')
                                      |substr(icd9_code, 1, 4) %in% c('0706','0709','5733','5734','5738','5739','V427')
                                      |substr(icd9_code, 1, 5) %in% c('07022','07023','07032','07033','07044','07054')
                                      |substr(icd10_code, 1, 3) %in% c('B18','K73','K74')
                                      |substr(icd10_code, 1, 4) %in% c('K700','K701','K702','K703','K709','K713','K714',
                                                                       'K715','K717','K760','K762','K763','K764','K768',
                                                                       'K769','Z944'), 1, 0)) %>% 
  mutate(diabetes_without_cc = if_else(substr(icd9_code, 1, 4) %in% c('2500','2501','2502','2503','2508','2509')
                                       |substr(icd10_code, 1, 4) %in% c('E100','E10l','E106','E108','E109','E110','E111',
                                                                        'E116','E118','E119','E120','E121','E126','E128',
                                                                        'E129','E130','E131','E136','E138','E139','E140',
                                                                        'E141','E146','E148','E149'), 1, 0)) %>% 
  mutate(diabetes_with_cc = if_else(substr(icd9_code, 1, 4) %in% c('2504','2505','2506','2507')
                                    |substr(icd10_code, 1, 4) %in% c('E102','E103','E104','E105','E107','E112','E113',
                                                                     'E114','E115','E117','E122','E123','E124','E125',
                                                                     'E127','E132','E133','E134','E135','E137','E142',
                                                                     'E143','E144','E145','E147'), 1, 0)) %>% 
  mutate(paraplegia = if_else(substr(icd9_code, 1, 3) %in% c('342','343')
                              |substr(icd9_code, 1, 4) %in% c('3341','3440','3441','3442',
                                                              '3443','3444','3445','3446','3449')
                              |substr(icd10_code, 1, 3) %in% c('G81','G82')
                              |substr(icd10_code, 1, 4) %in% c('G041','G114','G801','G802','G830',
                                                               'G831','G832','G833','G834','G839'), 1, 0)) %>% 
  mutate(renal_disease = if_else(substr(icd9_code, 1, 3) %in% c('582','585','586','V56')
                                 |substr(icd9_code, 1, 4) %in% c('5880','V420','V451')
                                 |substr(icd9_code, 1, 4) %in% c('5830','5831','5832','5833',
                                                                 '5834','5835','5836','5837')
                                 |substr(icd9_code, 1, 5) %in% c('40301','40311','40391','40402','40403','40412','40413','40492','40493')
                                 |substr(icd10_code, 1, 3) %in% c('N18','N19')
                                 |substr(icd10_code, 1, 4) %in% c('I120','I131','N032','N033','N034',
                                                                  'N035','N036','N037','N052','N053',
                                                                  'N054','N055','N056','N057','N250',
                                                                  'Z490','Z491','Z492','Z940','Z992'), 1, 0)) %>% 
  mutate(severe_liver_disease = if_else(substr(icd9_code, 1, 4) %in% c('4560','4561','4562')
                                 |substr(icd9_code, 1, 4) %in% c('5722','5723','5724','5725','5726','5727','5728')
                                 |substr(icd10_code, 1, 4) %in% c('I850','I859','I864','I982','K704','K711',
                                                                  'K721','K729','K765','K766','K767'), 1, 0)) %>% 
  mutate(metastatic_solid_tumor = if_else(substr(icd9_code, 1, 3) %in% c('196','197','198','199')
                                        |substr(icd10_code, 1, 3) %in% c('C77','C78','C79','C80'), 1, 0)) %>% 
  mutate(aids = if_else(substr(icd9_code, 1, 3) %in% c('042','043','044')
                        |substr(icd10_code, 1, 3) %in% c('B20','B21','B22','B24'), 1, 0))

# mutate(malignant_cancer = if_else(substr(icd9_code, 1, 3) %in% c('140','141','142','143','144','145','146','147','148','149',
#                                                                  '150','151','152','153','154','155','156','157','158','159',
#                                                                  '160','161','162','163','164','165','166','167','168','169',
#                                                                  '170','171','172')
#                                |substr(icd9_code, 1, 4) %in% c('1740','1741','1742','1743','1744','1745','1746','1747','1748','1749',
#                                                                '1750','1751','1752','1753','1754','1755','1756','1757','1758','1759',
#                                                                '1760','1761','1762','1763','1764','1765','1766','1767','1768','1769',
#                                                                '170','171','172') #between 1740 and 1958
#                                |substr(icd9_code, 1, 3) %in% c('5830','5831','5832','5833',
#                                                                '5834','5835','5836','5837')#between 200 and 208
#                                |substr(icd9_code, 1, 4) %in% c('2386')


#admissions 랑 diag 조인하기 hadm_id로 group by hadm_id


admissions <- dplyr::tbl(conn, dbplyr::in_schema("mimic_core", "admissions"))

com <- admissions %>% left_join(diag, by=c("subject_id", "hadm_id")) %>% group_by(hadm_id)
com


 
ag <- mimic_derived.age %>% mutate(age_score  = ifelse(age <= 40, 0, 
                                                       ifelse(age <=50, 1,
                                                              ifelse(age <= 60, 2, 
                                                                     ifelse(age <=70, 3, 4)))) %>% 
                                     select(hadm_id, age, age_score)

       
       
admissions %>% left_join(com, by=c("subject_id","hadm_id")) %>% 
  left_join(ag, by=c("subject_id","hadm_id")) %>% 
  mutate(charlson_comorbidity_index = age_score
           + myocardial_infarct + congestive_heart_failure + peripheral_vascular_disease
           + cerebrovascular_disease + dementia + chronic_pulmonary_disease
           + rheumatic_disease + peptic_ulcer_disease
           + GREATEST(mild_liver_disease, 3*severe_liver_disease)
           + GREATEST(2*diabetes_with_cc, diabetes_without_cc)
           + GREATEST(2*malignant_cancer, 6*metastatic_solid_tumor)
           + 2*paraplegia + 2*renal_disease 
           + 6*aids) %>% select(subject_id, hadm_id, age_score, myocardial_infarct, congestive_heart_failure, peripheral_vascular_disease,
       cerebrovascular_disease
       , dementia
       , chronic_pulmonary_disease
       , rheumatic_disease
       , peptic_ulcer_disease
       , mild_liver_disease
       , diabetes_without_cc
       , diabetes_with_cc
       , paraplegia
       , renal_disease
       , malignant_cancer
       , severe_liver_disease 
       , metastatic_solid_tumor 
       , aids
       , charlson_comorbidity_index)

