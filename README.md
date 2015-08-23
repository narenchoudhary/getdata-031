# getdata-031 Course Project
Getting and Cleaning Data Course Project Repository

## Objective

The goal is to prepare tidy data from the data provided by the source.

## Data
Human Activity Recognition Using Smartphones Dataset  

Data : [getdata-031 Course Project Data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 

Origianl data repository: [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)  

## Analysis

The modifications and analysis done by R Script `run_analysis.R` is explained in following sections.

### Part 0 

The files used to load data for analysis are:


* `test/subject_test.txt`  
* `test/X_test.txt`  
* `test/y_test.txt`  
* `train/subject_train.txt`  
* `train/X_train.txt`  
* `train/y_train.txt`  
* `activity_labels.txt`
* `features.txt`

Read data from these files to variables.  
Look at the specifications of the data by running `ncol`, `nrow`, `str` and `names` functions on the variables.  

Name the columns of the data sets using `colnames` or `setNames`.

### Part 1

* Merge all test data together using `cbind`.
* Merge all train data together using `cbind`.
* Merge already combined test and train data sets together using `rbind`.

### Part 2

* Create logical vector to filter out the required columns out of merged data set.
* Only `Mean` and `Stand deviation` measurements are required.
* Keep `activityId` and `subjectId` identifiers also for taking averages in Part 5.

### Part 3

* Use `factor` function to replace `activityId` with `activityNames`.  

### Part 4

* Some of the measurements have descriptive labels in their names.
* Identidy them.
    * prefix `t` for time
    * prefix `f` for frequency 
    * abbreviation `Acc` for Accelerometer
    * abbreviation `Gyro` for Gyroscope
    * abbreviation `Mag` for Magnitude
    * replace `BodyBody` with `Body`
* Replace them with appropriate labels.

### Part 5

* load `reshape2` package.
* Melt the data by `activityId` and `subjectId` variables.
* Use `dcast` on molten data set to calculate mean.


### Part 6

* Use `write.table` to write data frame to `finalTidyData.txt` with `row.names = F`.


## Packages used

* `r-base`
* `reshape2`
* `dplyr`
