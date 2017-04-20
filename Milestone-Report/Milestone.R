# Set working directory
setwd("Z:/SpringBoard/Foundations of Data Science/Capstone project/FEVS2015_PRDF_CSV")

# load dataset
survey_all <- read.csv("evs2015_PRDF.csv", na.strings=c(""," "), stringsAsFactors = FALSE)
str(survey_all)
head(survey_all)
class(survey_all)
names(survey_all)

# Select useful columns for anlysis
survey <- survey_all[ , c("POSTWT", "agency", "Q2", "Q3", "Q4", "Q6", "Q11", "Q12", "Q23", "Q24", "Q25", "Q30", "Q32", "Q34", "Q37", "Q38", "Q40", "Q42", "Q45", "Q46", "Q47", "Q48", "Q49", "Q50", "Q51", "Q52", "Q53", "Q54", "Q55", "Q56", "Q58", "Q59", "Q60", "Q61", "Q69", "Q70",  "Q71", "DSUPER", "DSEX", "DMINORITY", "DEDUC", "DFEDTEN", "DRETIRE", "DDIS", "DAGEGRP", "DMIL", "DLEAVING", "RANDOM")]
names(survey)

# remove rows with NA values
survey1 <- na.omit(survey)
str(survey1)

# Select 20k rows of dataset for analysis
survey2 <- survey1[sample(nrow(survey1), 20000), ]
str(survey2)

# plots and histograms of 2-3 columns in the dataset
age <- table(survey2$DAGEGRP)
barplot(age)
gender <- table(survey2$DSEX)
barplot(gender)
long <- table(survey2$DFEDTEN)
barplot(long)

# Change DSEX and DAGEGRP columns into factor
sex <- as.factor(survey2$DSEX)
levels(sex)
levels(sex) <- c("Male", "Female")
levels(sex)
survey2$DSEX <- sex
library(ggplot2)
ggplot(survey2, aes(x = DSEX)) + geom_bar()
age <- as.factor(survey2$DAGEGRP)
levels(age) <- c("Under 40", "40-49", "50-59", "60 or older")
survey2$DAGEGRP <- age
ggplot(survey2, aes(x = DAGEGRP)) + geom_bar()

# See the relationship among columns in the data set
# Q40: I recommend my organization as a good place to work.
survey2$Q40 <- as.factor(survey2$Q40)
levels(survey2$Q40)
# reorder levels of Q40
survey2$Q40 <- factor(survey2$Q40, levels = c("5", "4", "3", "2", "1"))
# Plot of answer broken down by gender
ggplot(survey2, aes(x = Q40)) + geom_bar() + facet_wrap(~ DSEX)
ggplot(survey2, aes(x = Q40)) + geom_bar() + facet_wrap(~ DAGEGRP)
# Create side-by-side barchart
ggplot(survey2, aes(x = Q40, fill = DSEX)) + geom_bar(position = "dodge")
ggplot(survey2, aes(x = Q40, fill = DAGEGRP)) + geom_bar(position = "dodge")
ggplot(survey2, aes(x = DSEX, fill = Q40)) + geom_bar(position = "dodge")
ggplot(survey2, aes(x = DAGEGRP, fill = Q40)) + geom_bar(position = "dodge")

# Plot proportion of answer, conditional on gender
ggplot(survey2, aes(x = DSEX, fill = Q40)) + geom_bar(position = "fill")
ggplot(survey2, aes(x = DAGEGRP, fill = Q40)) + geom_bar(position = "fill")

# Generate tables of joint and conditional proportions, respectively:
tab_sex <- table(survey2$DSEX, survey2$Q40)
tab_sex
prop.table(tab_sex)     # Joint proportions
prop.table(tab_sex, 1)  # Conditional on rows
prop.table(tab_sex, 2)  # Conditional on columns
round(prop.table(tab_sex, 1)*100,2)
  
tab_age <- table(survey2$DAGEGRP, survey2$Q40)
tab_age
prop.table(tab_age, 1)  # Conditional on rows
prop.table(tab_age, 2)  # Conditional on columns
round(prop.table(tab_age, 1)*100,2)

# Analyze results of different agencys: 
# AR--Department of the Army;   CM--Department of Commerce;
# DJ--Department of Justice;    DL--Department of Labor;
# ED--Department of Education;  TD--Department of Transportation
survey3 <- subset(survey, agency=="AR" | agency=="CM" | agency=="DJ" | agency=="DL" | agency=="ED" | agency=="TD")
survey3 <- na.omit(survey3)
str(survey3)

# Select 20k rows of dataset for analysis
survey4 <- survey3[sample(nrow(survey3), 20000), ]
str(survey4)
  
# Change agency into factor
agenc <- as.factor(survey4$agency)
levels(agenc)
levels(agenc) <- c("Army", "Commerce", "Justice", "Labor", "Education", "Transport")
levels(agenc)
survey4$agency <- agenc
ggplot(survey4, aes(x = agency)) + geom_bar()

# See the relationship of different agencies in the data set
# Q40: I recommend my organization as a good place to work.
survey4$Q40 <- as.factor(survey4$Q40)
# reorder levels of Q40
survey4$Q40 <- factor(survey4$Q40, levels = c("5", "4", "3", "2", "1"))
levels(survey4$Q40)
# Create side-by-side barchart
ggplot(survey4, aes(x = agency, fill = Q40)) + geom_bar(position = "dodge")
# Plot proportion of answer, conditional on agency
ggplot(survey4, aes(x = agency, fill = Q40)) + geom_bar(position = "fill")

# Generate tables of conditional proportions:
tab_agency <- table(survey4$agency, survey4$Q40)
tab_agency
round(prop.table(tab_agency, 1)*100,2)	# Conditional on rows
  
# Same analysis for Q69, Q70 and Q71
# Q69: Considering everything, how satisfied are you with your job?
survey2$Q69 <- as.factor(survey2$Q69)
survey2$Q69 <- factor(survey2$Q69, levels = c("5", "4", "3", "2", "1"))
# Create side-by-side barchart
ggplot(survey2, aes(x = DSEX, fill = Q69)) + geom_bar(position = "dodge")
ggplot(survey2, aes(x = DAGEGRP, fill = Q69)) + geom_bar(position = "dodge")
# Plot proportion of answer, conditional on gender and age group
ggplot(survey2, aes(x = DSEX, fill = Q69)) + geom_bar(position = "fill")
ggplot(survey2, aes(x = DAGEGRP, fill = Q69)) + geom_bar(position = "fill")

# Generate tables of conditional proportions:
tab_sex_Q69 <- table(survey2$DSEX, survey2$Q69)
tab_sex_Q69
round(prop.table(tab_sex_Q69, 1)*100,2)	# Conditional on rows
tab_age_Q69 <- table(survey2$DAGEGRP, survey2$Q69)
tab_age_Q69
round(prop.table(tab_age_Q69, 1)*100,2)	# Conditional on rows

survey4$Q69 <- as.factor(survey4$Q69)
survey4$Q69 <- factor(survey4$Q69, levels = c("5", "4", "3", "2", "1"))
# Create side-by-side barchart
ggplot(survey4, aes(x = agency, fill = Q69)) + geom_bar(position = "dodge")
# Plot proportion of answer, conditional on agency
ggplot(survey4, aes(x = agency, fill = Q69)) + geom_bar(position = "fill")

# Generate tables of conditional proportions:
tab_agency_Q69 <- table(survey4$agency, survey4$Q69)
tab_agency_Q69
round(prop.table(tab_agency_Q69, 1)*100,2)	# Conditional on rows
  
# Q71: Considering everything, how satisfied are you with your organization?
survey2$Q71 <- as.factor(survey2$Q71)
survey2$Q71 <- factor(survey2$Q71, levels = c("5", "4", "3", "2", "1"))
# Create side-by-side barchart
ggplot(survey2, aes(x = DSEX, fill = Q71)) + geom_bar(position = "dodge")
ggplot(survey2, aes(x = DAGEGRP, fill = Q71)) + geom_bar(position = "dodge")
# Plot proportion of answer, conditional on gender and age group
ggplot(survey2, aes(x = DSEX, fill = Q71)) + geom_bar(position = "fill")
ggplot(survey2, aes(x = DAGEGRP, fill = Q71)) + geom_bar(position = "fill")

# Generate tables of conditional proportions:
tab_sex_Q71 <- table(survey2$DSEX, survey2$Q71)
round(prop.table(tab_sex_Q71, 1)*100,2)	# Conditional on rows
tab_age_Q71 <- table(survey2$DAGEGRP, survey2$Q71)
round(prop.table(tab_age_Q71, 1)*100,2)	# Conditional on rows

survey4$Q71 <- as.factor(survey4$Q71)
survey4$Q71 <- factor(survey4$Q71, levels = c("5", "4", "3", "2", "1"))
# Create side-by-side barchart
ggplot(survey4, aes(x = agency, fill = Q71)) + geom_bar(position = "dodge")
# Plot proportion of answer, conditional on agency
ggplot(survey4, aes(x = agency, fill = Q71)) + geom_bar(position = "fill")

# Generate tables of conditional proportions:
tab_agency_Q71 <- table(survey4$agency, survey4$Q71)
round(prop.table(tab_agency_Q71, 1)*100,2)	# Conditional on rows


  

