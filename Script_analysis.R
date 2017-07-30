# Downloading and unzipping the data folder

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "data.zip")
list.files()
unzip("data.zip")

# Loading libraries and all test data files from test folder

library(dplyr)
library(plyr)
subject_test <- read.table("~/Data/test/subject_test.txt")
X_test <- read.table("~/Data//test/X_test.txt")
activity_test <- read.table("~/Data/test/y_test.txt")

# Loading features or measured varibales and activities performed by subjects 

features_txt <-read.table("~/Data/features.txt")
activities <- read.table("~/Data/activity_labels.txt",header = FALSE)

# Checking diemnsions of test data files and features

dim(subject_test)
dim(activity_test)
dim(X_test)
dim(features_txt)

# Assigning column names to subject_test, actvities_test and X_test data files o
# of test data

colnames(subject_test) <- "subject_Id"
colnames(activity_test) <-"activity_Id"
colnames(X_test) <- features_txt[, 2]

# Combining test data together columnwise as they have same numbers of rows

alltest_data <- cbind(subject_test, activity_test, X_test)

# Loading all data files from train folder

subject_train <- read.table("~/Data/train/subject_train.txt")
X_train <- read.table("~/Data/train/X_train.txt")
activity_train <- read.table("~/Data/train/y_train.txt")

# Checking the dimensions

dim(subject_train)
dim(activity_train)
dim(X_train)

# Labeling actvities data with actvity_Id and corresponding actvity name

colnames(activities) <- c('activity_Id','activity_Name')

# Assigning column names to subject_train, actvities_train and X_train data files 
# of training data

colnames(subject_train) <- "subject_Id"
colnames(activity_train) <-"activity_Id"
colnames(X_train) <- features_txt[, 2]

# Combining test data together columnwise as they have same numbers of rows

alltrain_data <- cbind(subject_train,activity_train, X_train)

# Mergeing test and traning data 

alldata <- rbind(alltest_data, alltrain_data)

# Labeling the acitvity_ID coresspondng to their actvity type

alldata$activity_Id <- factor(alldata$activity_Id, levels=c(1:6), labels=activities[ ,2])

# Extracting the data subset that consists of only mean and std measurements

alldata_mean_std <- alldata[,grepl("mean|std|subject_Id|activity_Id",colnames(alldata))]

# Creating independent tidy data set with the average of each variable for each activity
# and each subject

library(reshape2)
data_melt <- melt(alldata_mean_std, id = c("subject_Id", "activity_Id"), measure.vars = colnames(alldata_mean_std[0,3:81]))
averagedData <- dcast(data_melt, subject_Id + activity_Id ~ variable, mean)

# Formating the variables names

colnames(averagedData) <- gsub("\\()", "", colnames(averagedDat))
colnames(averagedData) <- gsub("-", "_",colnames(averagedDat))

# Writing "averageData" file as "tidy_data.txt" file in tabular form

write.table(averagedData,"tidy_data.txt",row.name = FALSE,quote = FALSE)

