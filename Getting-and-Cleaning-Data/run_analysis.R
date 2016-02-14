# run_analysis.R
# Here are the data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
# clear workspace and import test data
rm(list = ls())
setwd("C:/Users/natehow/Documents/Coursera/UCI HAR Dataset")

# 1. Merge training and test set together
activityType <- read.table("activity_labels.txt", header = FALSE)
features <- read.table("features.txt",header = FALSE)
testGroupData <- read.table("test/x_test.txt",header = FALSE)
testSubjects <- read.table("test/subject_test.txt", header = FALSE)
testActivity <- read.table("test/y_test.txt",header = FALSE)

#change column names
colnames(testGroupData) <- tolower(features[,2])
colnames(testSubjects) <- "subject"
colnames(testActivity) <- "activityid"
colnames(activityType) <- c("activityid","activity")

#Combine into test data
testData <- cbind(testSubjects,testActivity,testGroupData)

#Import Train Data
trainGroupData <- read.table("train/x_train.txt",header = FALSE)
trainSubjects <- read.table("train/subject_train.txt", header = FALSE)
trainActivity <- read.table("train/y_train.txt",header = FALSE)

#change column names
colnames(trainGroupData) <- tolower(features[,2])
colnames(trainSubjects) <- "subject"
colnames(trainActivity) <- "activityid"

trainData <- cbind(trainSubjects,trainActivity,trainGroupData)

combinedDataSet <- rbind(testData,trainData)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
columns <- tolower(colnames(combinedDataSet))
MeanStdLogical <- grepl("mean..$",columns) | grepl("std..$",columns)
MeanStdLogical[1:2] <- TRUE #Keeps test subject and activity ID columns
MeanStdDataSet <- combinedDataSet[MeanStdLogical]

# 3. Uses descriptive activity names to name the activities in the data set
MeanStdDataSet <- merge(activityType,MeanStdDataSet,by = "activityid")

# 4. Appropriately labels the data set with descriptive variable names.
columns <- colnames(MeanStdDataSet)
for (i in 1:length(columns)) {
  columns[i] <- gsub("\\()","",columns[i])
  columns[i] <- gsub("-std","stddev",columns[i])
  columns[i] <- gsub("-mean","mean",columns[i])
  columns[i] <- gsub("^t","time",columns[i])
  columns[i] <- gsub("^f","freq",columns[i])
  columns[i] <- gsub("bodybody","body",columns[i])
}

#changes column names in data set 
colnames(MeanStdDataSet) <- columns

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
meltedData <- melt(MeanStdDataSet,id = c("subject","activity"),measure.vars = columns[4:length(columns)])
tidyData <- dcast(meltedData,subject + activity ~ variable,mean)

#write table to a text file
write.table(tidyData,"tidyData.txt",row.names = FALSE)