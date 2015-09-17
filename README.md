# Creating the Tidy Dataset from the raw data available from Human Activity Recognition Using Smartphone Dataset

## Objective
As part of the course project for getting and cleaning data at Coursera the activity of creating an independent tidy data set from the UCI HAR Dataset was undertaken. The specifications of what the final dataset should represent was outlined in the course project as following:

* Merge the training and the test sets to create one data set.
* Extract only the measurements on the mean and standard deviation for each measurement. 
* Use descriptive activity names to name the activities in the data set
* Appropriately label the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps Undertaken

To achieve the objective mentioned above an R script was prepared (run_analysis.R) which does the following steps:

* Loads the UCI HAR dataset files (X_train.txt, X_test.txt, Y_train.txt, y_test.txt, subject_train.txt, subject_test.txt, features.txt, activity_labels.txt). This step assumes that the unzipped version of the dataset UCI HAR Dataset.zip) is available in the working directory.
* Merge the training and test datasets using the rbind() function giving data frames x_merged, y_merged, sub_merged.
* Extracts the features corresponding to mean and standard deviation from merged data frame x_merged. This step looks for text "mean()" and "std()" in the feature names as loaded from features.txt. This gives a reduced data frame x_subset.
* Creates more meaningful names of the feature by substituting acronym like 't', 'f' with their intended meaning like "Time" & "Frequency" respectively. Similarly replacing the function names "mean()" and "std()" with their intended behaviour like "Mean" & "StdDev" respectively. Finally removing all '-'. This gives the format of feature name as,
	{Time|Frequency}{Body|Gravity}{Acc|AccJerk|Gyro|GyroJerk}{Mean|StdDev}{X|Y|Z|Mag}
* Creates the integer vector of subjects form the data frame sub_merged.
* Replaces the activity ID in dataset y_merged with the descriptive activity names as provided by data loaded from activity_lables.txt. Finally replacing all '-' with blank space. This gives a character vector activities.
* Merging the dataset x_subset with vectors subjects and activities with suitable column names. This gives the data frame data_final.
* Creating an independent data frame from the final data frame data_final. This step use the group_by(), summarise_each() functional and chain operator from dplyr package. The dplyr package has been loaded at the top of the script and assumes this package has been installed. This step produces a data frame data_tidy.
* Finally writing the data frame data_tidy to the text file data_tidy.txt at the working directly using the write.table function with row.name set to False. This file is also read back using read.table to ensure sanity.

## How to Use Script
* Download the UCI HAR dataset from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
* Unzip the dataset UCI HAR Dataset.zip at your working directory
* Place the script run_analysis.R at the working directory
* Ensure R package "dplyr" is avialble for use, if not please install this package using,
	install.packages("dplyr")
* Source the R script using ,
	source("run_analysis.R")
* Execute the function run_analysis() using,
	run_analysis()
* Inspect the generated text file data_tidy.txt in the working directory
* You can load the generated text file in the working directory using,
	read.table("./data_tidy.txt", header=TRUE)