# ---
# script: 02-DataCollect
# subject: Looking for data and first analysis
# date: 2019-06-28
# author: Marcus Di Paula
# github: github.com/marcusdipaula/
# linkedin: linkedin.com/in/marcusdipaula/
# ---

# 2. Looking for data: 
#     - Identify entities (and its attributes) of the problem 
#       Entities: Attributes (variables) that could help to predict good or bad credit
#       concession, such as Job, Housing, Age, Sex, Savings Account, Purpose, Duration, etc
#       
#       The features of each attribute (or variable) are its kind/type/characteristic, example: 
#       Sex: male or female       
#       
#     - Collect data that represents entities
#       Will be used the German credit dataset*, with an addition of a 21th** column 
#       (attribute/variable) that represents the historical definition for each concession (row).
#
#       * Original dataset: https://archive.ics.uci.edu/ml/datasets/Statlog+%28German+Credit+Data%29
#       ** Dataset with addition: https://github.com/marcusdipaula/dsa-credit-analysis/blob/master/credit.csv
#
#     - Which hypotheses could I suppose?
#     - Explore the data (superficially) to understand it 
#     - Could I use an algorithm to address the issue or solve it? Which one?



# loading the tidyverse packages (and installing it first, if not installed)
if(!require(tidyverse)) {install.packages("tidyverse"); library(tidyverse)}


# loading the dataset
credit <- read_csv("credit.csv", col_names = c("Checking_Account",
                                               "Duration_Month",
                                               "Credit_History",
                                               "Purpose",
                                               "Credit_Amount",
                                               "Savings_Account",
                                               "Employment",
                                               "Installment_Rate_Percent",
                                               "Sex_and_Status",
                                               "Other_Guarantors",
                                               "Present_Residence_Time",
                                               "Property",
                                               "Age",
                                               "Other_Installment_Plans",
                                               "Housing",
                                               "Existing_Credits_At_Bank",
                                               "Job_Skill",
                                               "Dependents",
                                               "Telephone",
                                               "Foreign_Worker",
                                               "Credit_Rating"),
                   
                                col_types = cols(.default = "f",
                                                 Duration_Month = "i",
                                                 Credit_Amount = "i",
                                                 Installment_Rate_Percent = "i",
                                                 Present_Residence_Time = "i",
                                                 Age = "i",
                                                 Existing_Credits_At_Bank = "i",
                                                 Dependents = "i",
                                                 Credit_Rating = "i"))

# Changing values of Credit_Rating to convert it to factor
  # which is the number of the column Credit_Rating?
which(colnames(credit)=="Credit_Rating") 
  # alternative: match("Credit_Rating", names(credit))
  # alternative: grep("Credit_Rating", colnames(credit))

  # Which values do we have in it?
table(credit[,21])

  # attributing a new value to each old value, according to the data dictionary below
credit[credit[,21]==1, 21] <- c("Good") # alternative: credit[,21] <- ifelse(credit$Credit_Rating==1,"Good","Bad")
credit[credit[,21]==2, 21] <- c("Bad")

  # Converting Credit_Rating to factor
credit[,21] <- type_convert(credit[,"Credit_Rating"], col_types = "f")

# Removing the attributes created by read_csv function, as they
# meant to store how the data was originally read, so it wont be 
# necessary for further manipulations
attr(credit, "spec") <- NULL

# Getting a view on how our dataset is strucured 
# str(credit)
# glimpse(credit) 

# by factor columns
# glimpse(credit[ , sapply(credit, is.factor)])
# str(credit[ , sapply(credit, is.factor)])

# # by integer columns
# glimpse(credit[ , sapply(credit, is.integer)])
# str(credit[ , sapply(credit, is.integer)])


# Renaming some factors
credit$Purpose <- recode_factor(credit$Purpose, A43 = "radio_tv",
                                A46 = "education",
                                A42 = "furniture_equipment",
                                A40 = "car_new",
                                A41 = "car_used",
                                A49 = "business",
                                A44 = "domestic_appliances",
                                A45 = "repairs",
                                A410 = "others",
                                A48  = "retraining")

credit$Job_Skill <- recode_factor(credit$Job_Skill, A171 = "unskilled_non-resid",
                                  A172 = "unskilled_resid",
                                  A173 = "skilled",
                                  A174 = "highly_skilled")

credit$Credit_History <- recode_factor(credit$Credit_History, A30 = "no_cred_taken",
                                       A31 = "all_cred_paid",
                                       A32 = "existing_cred_till_now",
                                       A33 = "delay_in_paying_in_past",
                                       A34 = "critical_account")



#### Data dictionary (Original Dataset) ####
# 
# Attribute 1: Status of existing checking account (qualitative)
#      (Value: Meaning)
#        A11 :      ... <    0 DM
#        A12 : 0 <= ... <  200 DM
#        A13 :      ... >= 200 DM / salary assignments for at least 1 year
#        A14 : no checking account
# 
# 
# Attribute 2: Duration in month (numerical)
# 
# 
# Attribute 3: Credit history (qualitative)
#      (Value: Meaning)
#        A30 : no credits taken/all credits paid back duly
#        A31 : all credits at this bank paid back duly
#        A32 : existing credits paid back duly till now
#        A33 : delay in paying off in the past
#        A34 : critical account/other credits existing (not at this bank)
# 
# Attribute 4: Purpose (qualitative)
#      (Value: Meaning)
#        A40 : car (new)
#        A41 : car (used)
#        A42 : furniture/equipment
#        A43 : radio/television
#        A44 : domestic appliances
#        A45 : repairs
#        A46 : education
#        A47 : (vacation - does not exist?)
#        A48 : retraining
#        A49 : business
#       A410 : others
# 
# Attribute 5: Credit amount (numerical)
# 
# 
# Attribute 6: Savings account/bonds (qualitative)
#      (Value: Meaning)
#        A61 :          ... <  100 DM
#        A62 :   100 <= ... <  500 DM
#        A63 :   500 <= ... < 1000 DM
#        A64 :          .. >= 1000 DM
#        A65 :   unknown/ no savings account
# 
# 
# Attribute 7:  Present employment since (qualitative)
#      (Value: Meaning)
#        A71 : unemployed
#        A72 :       ... < 1 year
#        A73 : 1  <= ... < 4 years
#        A74 : 4  <= ... < 7 years
#        A75 :       .. >= 7 years
# 
# 
# Attribute 8: Installment rate in percentage of disposable income (numerical)
# 
# 
# Attribute 9:  Personal status and sex (qualitative)
#      (Value: Meaning)
#        A91 : male   : divorced/separated
#        A92 : female : divorced/separated/married
#        A93 : male   : single
#        A94 : male   : married/widowed
#        A95 : female : single
# 
#        
# Attribute 10: Other debtors / guarantors (qualitative)
#       (Value: Meaning)
#        A101 : none
#        A102 : co-applicant
#        A103 : guarantor
# 
#        
# Attribute 11: Present residence since (numerical)
# 
# 
# Attribute 12: Property (qualitative)
#       (Value: Meaning)
#        A121 : real estate
#        A122 : if not A121 : building society savings agreement/life insurance
#        A123 : if not A121/A122 : car or other, not in attribute 6
#        A124 : unknown / no property
# 
# Attribute 13: Age in years(numerical)
#           
# 
# Attribute 14: Other installment plans (qualitative)
#       (Value: Meaning)
#        A141 : bank
#        A142 : stores
#        A143 : none
# 
#        
# Attribute 15: Housing (qualitative)
#       (Value: Meaning)
#        A151 : rent
#        A152 : own
#        A153 : for free
# 
#        
# Attribute 16: Number of existing credits at this bank (numerical)
# 
# 
# Attribute 17: Job (qualitative)
#       (Value: Meaning)
#        A171 : unemployed/ unskilled  - non-resident
#        A172 : unskilled - resident
#        A173 : skilled employee / official
#        A174 : management/ self-employed/highly qualified employee/ officer
# 
# 
# Attribute 18: Number of people being liable to provide maintenance for (numerical)
# 
#               
# Attribute 19: Telephone (qualitative)
#       (Value: Meaning)  
#        A191 : none
#        A192 : yes, registered under the customers name
# 
#        
# Attribute 20: foreign worker (qualitative)
#       (Value: Meaning)
#        A201 : yes
#        A202 : no
# 
#        
# Attribute 21: Credit Rating (numerical)
#       (Value: Meaning)
#           1 : Good
#           2 : Bad
