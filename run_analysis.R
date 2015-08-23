library(plyr)
library(dplyr)

# Read in features.txt file which contains list of all features
features <- read.table("features.txt", header = F)
features.names <- features$V2


# Read in the activity_labels.txt file which contains list of activities
activity_lables <- read.table("activity_labels.txt", header = F)
# Add column names to activity_lables
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


# All data needed for merging and tifying data is read

# No of rows in x_test, y_test and subject_test is equal
# These files hence can be joined to created a combined test data file
test_merged <- cbind(subject_test, y_test, x_test)

# No of rows in x_train, y_train and subject_train is equal
# These files hence can be joined to created a combined train data file
train_merged <- cbind(subject_train, y_train, x_train)

# ncol(test_merged) is equal to ncol(train_merged)
# These two files have same colnames as well (can be checked by names(test_merged) and names(train_merged))
# These two files can be merged using rbind()
test_train_merged <- rbind(test_merged, train_merged)

# Only "mean" and "standard deviation" values for every measurenment is required
# Separate the columns which contain 'mean' and 'std' in their names from test_train_merged
test_train_merged.colnames <- colnames(test_train_merged)
requiredColnames <- (grepl("activity..",test_train_merged.colnames) | grepl("subject..",test_train_merged.colnames) | grepl(".*mean.*",test_train_merged.colnames) | grepl(".*std.*",test_train_merged.colnames))
test_train_merged_refined <- test_train_merged[requiredColnames == T]

finalData <- merge(test_train_merged_refined, activity_lables, by = "activityId", all.x = T)

write.table(finalData, "./finalTidyData.txt", sep = "\t", row.names = T)