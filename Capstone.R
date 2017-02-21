# Set working directory
setwd("Z:/SpringBoard/Foundations of Data Science/Capstone project/FEVS2015_PRDF_CSV")

# load dataset
survey_all <- read.csv("evs2015_PRDF.csv", na.strings=c(""," ", "X"), stringsAsFactors = FALSE)
str(survey_all)
head(survey_all)
class(survey_all)
names(survey_all)

# Select useful columns for anlysis
survey <- survey_all[ , c("agency", "Q1", "Q2", "Q3", "Q4", "Q6", "Q9", "Q10", "Q11", "Q12", "Q15", "Q16", "Q17", "Q18", "Q19", "Q22", "Q23", "Q24", "Q25", "Q30", "Q32", "Q34", "Q37", "Q38", "Q40", "Q42", "Q44", "Q45", "Q46", "Q47", "Q48", "Q49", "Q50", "Q51", "Q52", "Q53", "Q54", "Q55", "Q56", "Q58", "Q59", "Q60", "Q61", "Q69", "Q70",  "Q71", "DSUPER", "DSEX", "DMINORITY", "DEDUC", "DFEDTEN", "DRETIRE", "DDIS", "DAGEGRP", "DMIL", "DLEAVING")]
names(survey)

# remove rows with NA values
survey1 <- na.omit(survey)
str(survey1)

# Select 20k rows of dataset for analysis
survey2 <- survey1[sample(nrow(survey1), 20000), ]
str(survey2)

# Add variables for Employee engagement index
# Leaders Lead
leaders <- (survey2$Q53 + survey2$Q54 + survey2$Q56 + survey2$Q60 + survey2$Q61)/5 -3
str(leaders)
# Supervisors
supervisors <- (survey2$Q47 + survey2$Q48 + survey2$Q49 + survey2$Q51 + survey2$Q52)/5 - 3
str(supervisors)
# Intrinsic Work Experience
experience <- (survey2$Q3 + survey2$Q4 + survey2$Q6 + survey2$Q11 + survey2$Q12)/5 - 3
str(experience)
# Employee engagement index
survey2$engagement <- (leaders + supervisors + experience)/3
str(survey2$engagement)

# Global Satisfaction Index
survey2$satisfaction <- (survey2$Q40 + survey2$Q69 + survey2$Q70 + survey2$Q71)/4 - 3
str(survey2$satisfaction)

str(survey2)

# Set engagement variable to indicate if the employee is engagement to the organization
positive <- function(v) {
  u <- as.integer(sign(v))
  for(i in 1:length(v))
  {
    if (v[i] <= 0) { 
      u[i] <- 0 }
  }
  return(u)
}
survey3 <- survey2
survey3$engagement <- as.factor(positive(survey2$engagement))
survey3$satisfaction <- as.factor(positive(survey2$satisfaction))
str(survey3)
levels(survey3$engagement)
levels(survey3$satisfaction)

# Exploratory Data Analysis
library(ggplot2)
library(scales)
# Gender
sex <- as.factor(survey3$DSEX)
levels(sex) <- c("Male", "Female")
survey3$DSEX <- sex
ggplot(survey3, aes(x = DSEX, fill = engagement)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Engagement of Gender", x = "Gender", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
ggplot(survey3, aes(x = DSEX, fill = satisfaction)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Satisfaction of Gender", x = "Gender", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
# Age group
age <- as.factor(survey3$DAGEGRP)
levels(age) <- c("Under 40", "40-49", "50-59", "60 or older")
survey3$DAGEGRP <- age
ggplot(survey3, aes(x = DAGEGRP, fill = engagement)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Engagement of Age group", x = "Age group", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
ggplot(survey3, aes(x = DAGEGRP, fill = satisfaction)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Satisfaction of Age group", x = "Age group", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
# Supervisor status
super <- as.factor(survey3$DSUPER)
levels(super) <- c("Non-Supervisor", "Supervisor")
survey3$DSUPER <- super
ggplot(survey3, aes(x = DSUPER, fill = engagement)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Engagement of Supervisor status", x = "Supervisor status", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
ggplot(survey3, aes(x = DSUPER, fill = satisfaction)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Satisfaction of Supervisor status", x = "Supervisor status", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
# Years of service
year <- as.factor(survey3$DFEDTEN)
levels(year) <- c("5 or fewer", "6-14", "15 or more")
survey3$DFEDTEN <- year
ggplot(survey3, aes(x = DFEDTEN, fill = engagement)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Engagement of Service years", x = "Years of service", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
ggplot(survey3, aes(x = DFEDTEN, fill = satisfaction)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Satisfaction of Service years", x = "Years of service", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
# Education degree
degree <- as.factor(survey3$DEDUC)
levels(degree) <- c("Prior Bachelor", "Bachelor", "Post-Bachelor")
survey3$DEDUC <- degree
ggplot(survey3, aes(x = DEDUC, fill = engagement)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Engagement of Education degree", x = "Education degree", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
ggplot(survey3, aes(x = DEDUC, fill = satisfaction)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Satisfaction of Education degree", x = "Education degree", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
# Consider leaving
leaving <- as.factor(survey3$DLEAVING)
levels(leaving) <- c("No", "Yes, within FG", "Yes, outside FG", "Yes, other")
survey3$DLEAVING <- leaving
ggplot(survey3, aes(x = DLEAVING, fill = engagement)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Engagement of Consider leaving", x = "Consider leaving", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
ggplot(survey3, aes(x = DLEAVING, fill = satisfaction)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Satisfaction of Consider leaving", x = "Consider leaving", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
# Agency
ggplot(survey3, aes(x = agency, fill = engagement)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Engagement of Agency", x = "Agency", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))
ggplot(survey3, aes(x = agency, fill = satisfaction)) + 
	geom_bar(position = "fill") + 
	scale_y_continuous(labels=percent, breaks = seq(0, 1, 0.1)) + 
	labs(title = "Satisfaction of Agency", x = "Agency", y = "Percentage") + 
	theme(plot.title = element_text(hjust = 0.5))

table(survey3$engagement)
16374/20000
install.packages("caTools")
library(caTools)

# Split dataset into training and test parts
set.seed(88)
# 80% data for training and 20% data for testing
split = sample.split(survey3$engagement, SplitRatio = 0.8)	  
surveyTrain = subset(survey3, split == TRUE)
surveyTest = subset(survey3, split == FALSE)
nrow(surveyTrain)
nrow(surveyTest)

# Build logistic regression model to predict engagement
SurveyLog <- glm(engagement~., data=surveyTrain, family="binomial")
summary(SurveyLog)
SurveyLog1 <- glm(engagement ~ agency + Q2 + Q10 + Q19 + Q34 + Q37 + Q38 + Q40 + Q42 + Q58 + Q59 + Q69 + Q70 + DMINORITY + DFEDTEN + DDIS + DMIL + DLEAVING + satisfaction, data=surveyTrain, family="binomial")
summary(SurveyLog1)
SurveyLog2 <- glm(engagement ~ Q2 + Q10 + Q19 + Q34 + Q37 + Q38 + Q40 + Q42 + Q58 + Q59 + Q69 + Q70 + DMINORITY + DFEDTEN + DDIS + DMIL + DLEAVING, data=surveyTrain, family="binomial")
summary(SurveyLog2)

# Predict training data set
predictTrain = predict(SurveyLog, type="response")
summary(predictTrain)
tapply(predictTrain, surveyTrain$engagement, mean)
predictTrain1 = predict(SurveyLog1, type="response")
summary(predictTrain1)
tapply(predictTrain1, surveyTrain$engagement, mean)
predictTrain2 = predict(SurveyLog2, type="response")
summary(predictTrain2)
tapply(predictTrain2, surveyTrain$engagement, mean)

# Confusion matrix: (compare predicted vs actual)
table(surveyTrain$engagement, predictTrain > 0.5)
13088/13099		# Sensitivity
2895/2901		# Specificity
table(surveyTrain$engagement, predictTrain > 0.7)
13074/13099
2901/2901
table(surveyTrain$engagement, predictTrain > 0.2)
13095/13099
2868/2901

# Receiver Operater Characteristic (ROC) Curve
install.packages("ROCR")
library(ROCR)
ROCRpred = prediction(predictTrain, surveyTrain$engagement)
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf)
plot(ROCRperf, colorize=TRUE)
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))
ROCRpred1 = prediction(predictTrain1, surveyTrain$engagement)
ROCRperf1 = performance(ROCRpred1, "tpr", "fpr")
plot(ROCRperf1)
plot(ROCRperf1, colorize=TRUE)
plot(ROCRperf1, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))
ROCRpred2 = prediction(predictTrain2, surveyTrain$engagement)
ROCRperf2 = performance(ROCRpred2, "tpr", "fpr")
plot(ROCRperf2)
plot(ROCRperf2, colorize=TRUE)
plot(ROCRperf2, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

# Predict test dataset with the model
predictTest = predict(SurveyLog, type="response", newdata=surveyTest)
summary(predictTest)
tapply(predictTest, surveyTest$engagement, mean)
table(surveyTest$engagement, predictTest > 0.5)
3267/3275	# Sensitivity
717/725		# Specificity
table(surveyTest$engagement, predictTest > 0.7)
3267/3275
721/725
table(surveyTest$engagement, predictTest > 0.2)
3267/3275
714/725

ROCRpredTest = prediction(predictTest, surveyTest$engagement)
auc = as.numeric(performance(ROCRpredTest, "auc")@y.values)
auc
ROCRperfTest = performance(ROCRpredTest, "tpr", "fpr")
plot(ROCRperfTest, colorize=TRUE)







