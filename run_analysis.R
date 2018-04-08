# 1. Merges the training and the test sets to create one data set.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.

features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

train_all <- cbind(subject_train, Y_train, X_train)

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

test_all <- cbind(subject_test, Y_test, X_test)

all_data <- rbind(train_all, test_all)

varNames <- c("subject", "activity_num", as.character(features$V2))
names(all_data) <- varNames

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
colNames <- colnames(all_data)

selected_var <- (grepl("subject", colNames)  |
                   grepl( "activity_num", colNames) |
                   grepl("mean..", colNames) |
                   grepl("std..", colNames))

selected_dataset <- all_data[ , selected_var == TRUE]

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_dataset <- aggregate(. ~subject + activity_num, selected_dataset, mean)

tidy_dataset<- tidy_dataset[order(tidy_dataset$subject, tidy_dataset$activity_num),]

write.table(tidy_dataset, file = "tidydata.txt", row.name=FALSE)
