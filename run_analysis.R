library(plyr) 
library(reshape2) 


## 1. Merge the training and the test sets to create one data set.
##

train <- read.table("UCIHARDataset/train/X_train.txt")
test <- read.table("UCIHARDataset/test/X_test.txt")

x_data <- rbind(train, test)

train <- read.table("UCIHARDataset/train/Y_train.txt")
test <- read.table("UCIHARDataset/test/Y_test.txt")

y_label  <- rbind(train, test)

train <- read.table("UCIHARDataset/train/subject_train.txt")
test <- read.table("UCIHARDataset/test/subject_test.txt")

subject <- rbind(train, test)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##

features <- read.table("UCIHARDataset/features.txt")

mean_std <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

x_data <- x_data[, mean_std]

names(x_data) <- features[mean_std, 2]



## 3.Uses descriptive activity names to name the activities in the data set
##

activities <- read.table("UCIHARDataset/activity_labels.txt")

y_label[,1] = activities[y_label[,1], 2]

names(y_label) <- "Activity"



## 4.Appropriately labels the data set with descriptive variable names. 
##

names(subject) <- "Subject"
tidy <- cbind(subject, y_label, x_data)



## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##

tidy.mean <- ddply(melt(tidy, id.vars=c("Subject", "Activity")), .(Subject, Activity), summarise, MeanSamples=mean(value)) 

 
write.csv(tidy.mean, file = "tidy_mean.txt",row.names = FALSE) 
write.csv(tidy, file = "tidy.txt",row.names = FALSE) 


