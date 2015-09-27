#getting data - project

# constants
trainFolder <- "UCI HAR Dataset/train"
testFolder <- "UCI HAR Dataset/test"

# download and unzip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="UCI_HAR_dataset.zip")
unzip("UCI_HAR_dataset.zip")

# read mapping tables
activity <- read.table("UCI HAR Dataset/activity_labels.txt",header=F,col.names=c("code","activity"))
features <- read.table("UCI HAR Dataset/features.txt",header=F,col.names=c("code","feature"))

# function to merge train and test data into a single data frame
readAndMerge <- function(file,col.names) {
  trainFile <- paste(trainFolder,paste0(file,"_train.txt"),sep="/")
  testFile <- paste(testFolder,paste0(file,"_test.txt"),sep="/")
  if (missing(col.names)) {
    trainData <- read.table(trainFile,header=F)
    testData <- read.table(testFile,header=F)
  } else {
    trainData <- read.table(trainFile,header=F,col.names=col.names)
    testData <- read.table(testFile,header=F,col.names=col.names)
  }
  rbind(trainData,testData)
}

# read merged data
subject <- readAndMerge("subject",col.names=c("subject.id"))
x <- readAndMerge("X")
y <- readAndMerge("Y",col.names=c("activity.id"))
body_acc_x <- readAndMerge("Inertial Signals/body_acc_x")
body_acc_y <- readAndMerge("Inertial Signals/body_acc_y")
body_acc_z <- readAndMerge("Inertial Signals/body_acc_z")
body_gyro_x <- readAndMerge("Inertial Signals/body_gyro_x")
body_gyro_y <- readAndMerge("Inertial Signals/body_gyro_y")
body_gyro_z <- readAndMerge("Inertial Signals/body_gyro_z")
total_acc_x <- readAndMerge("Inertial Signals/total_acc_x")
total_acc_y <- readAndMerge("Inertial Signals/total_acc_y")
total_acc_z <- readAndMerge("Inertial Signals/total_acc_z")

# set the column names to their feature
names(x) <- features$feature

# add the activity and subject columns
data <- cbind(y, x, subject)

# link activity with its label
d <- merge(x=data,y=activity,by.x="activity.id",by.y="code",sort=F)

# collect only mean or standard deviation data
nm <- colnames(data)
subcols <- nm[grep("t.*-(mean|std)",nm)]
subdata <- data[,c("activity.id","subject.id",subcols)]

# link activity with its label
tmpdata <- merge(x=subdata,y=activity,by.x="activity.id",by.y="code",sort=F)

# reorder columns for nicer reading
data <- tmpdata[c("activity","subject.id",subcols)]

#------------ summarise the data (step 5 in the exercise) -----------

library(dplyr)
summary <- data %>%
  group_by(activity,subject.id) %>%
  summarise_each(funs(mean))

# save result
write.table(summary,file="analysis.project.txt",row.names=F)
