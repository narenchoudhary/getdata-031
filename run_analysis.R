library(plyr)
library(dplyr)
library(reshape2)

# Part 0 :Read the data

# Read in features.txt file which contains list of all features
features <- read.table("features.txt", header = F)
features.names <- features$V2


# Read in the activity_labels.txt file which contains list of activities
activity_lables <- read.table("activity_labels.txt", header = F)
# Column1 of activity_labels contains activityId and column2 contains activityName
activity_lables <- setNames(activity_lables, c("activityId", "activityName"))


# Read in the data from test folder
x_test <- read.table("test/X_test.txt", header = F)
subject_test <- read.table("test/subject_test.txt", header = F)
y_test <- read.table("test/y_test.txt", header = F)

# Add column names to test files
x_test <- setNames(x_test, features.names)
subject_test <- setNames(subject_test, "subjectId")
y_test <- setNames(y_test, "activityId")


# Read in the data from train folder
x_train <- read.table("train/X_train.txt", header = F)
subject_train <- read.table("train/subject_train.txt", header = F)
y_train <- read.table("train/y_train.txt", header = F)

# Add columns names to train files
x_train <- setNames(x_train, features.names)
subject_train <- setNames(subject_train, "subjectId")
y_train <- setNames(y_train, "activityId")


# Part 1: Merge the data

# No of rows in x_test, y_test and subject_test is equal
# These files hence can be joined to created a combined test data file
test_data <- cbind(subject_test, y_test, x_test)

# No of rows in x_train, y_train and subject_train is equal
# These files hence can be joined to created a combined train data file
train_data <- cbind(subject_train, y_train, x_train)

# ncol(test_merged) is equal to ncol(train_merged)
# These two files have same colnames as well (can be checked by names(test_data) and names(train_data))
# These two files can be merged using rbind()
test_train_merged <- rbind(test_data, train_data)

# Part 2 : Extract only mean and standard deviation measurments

# Only "mean" and "standard deviation" values for every measurenment are required
# Separate the columns which contain 'mean' and 'std' in their names from test_train_merged
test_train_merged.colnames <- colnames(test_train_merged)
requiredColnames <- (grepl("activity..",test_train_merged.colnames) | grepl("subject..",test_train_merged.colnames) | grepl(".*mean.*",test_train_merged.colnames) | grepl(".*std.*",test_train_merged.colnames))
test_train_merged_refined <- test_train_merged[requiredColnames == T]

# Part 3: Use descriptive names to name activities

finalData <- test_train_merged_refined
finalData$activityId <- factor(finalData$activityId, levels = activity_lables[, 1], labels = activity_lables[, 2])

# Part 4: Change descriptive column names with more clearly understandable names
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequency", names(finalData))
names(finalData) <- gsub("Acc", "Accelerometer", names(finalData))
names(finalData) <- gsub("Gyro", "Gyrometer", names(finalData))
names(finalData) <- gsub("Mag", "Magnitude", names(finalData))
names(finalData) <- gsub("BodyBody", "Body", names(finalData))
names(finalData) <- gsub("[-()]", "", names(finalData))

# Part 5: Create a second, independent data set with average of each variable for every activity and every subject

#finalTidyData <- aggregate(. ~ subjectId + activityId, finalData, mean)
#finalTidyData <- arrange(finalTidyData, subjectId, activityId)

finalTidyData <- melt(finalData, id = c("activityId", "subjectId")) %>% dcast(subjectId + activityId ~ variable, mean) %>% arrange( subjectId, desc(activityId))

# Part 6 : Write the final tidy data to a file

write.table(finalTidyData, "./finalTidyData.txt", sep = " ", row.names = F, quote = F)