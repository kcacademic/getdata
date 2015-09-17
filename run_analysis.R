run_analysis <- function() {
	# The steps below loads the required library for execution of steps.
	library(dplyr)
  
	# The steps below load the data set from flat files assuming all of these are present
	# in the directory where this script is being executed.
	x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
	y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
	x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
	y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
	sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
	sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
	features <- read.table("./UCI HAR Dataset/features.txt")
	activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
	
	# The steps below merge the training-set and test-set individually for x, y and subject
	# data frames.
	x_merged <- rbind(x_train, x_test)
	y_merged <- rbind(y_train, y_test)
	sub_merged <- rbind(sub_train, sub_test)
	
	# The steps below extract the columns from data frame x_merged where these variables are 
	# either mean or standard deviation of the measurements using the data frame features.
	required_columns <- which(grepl("mean\\(\\)|std\\(\\)", features$V2))
	x_subset <- x_merged[,required_columns]
	
	# The steps below add descriptive and meaningful names to the columns of data frame x
	# by substituting the acronyms with their complete forms.
	variables <- features[required_columns,]
	variables <- gsub("^t", "Time", variables[,2])
	variables <- gsub("^f", "Frequency", variables)
	variables <- gsub("-mean\\(\\)", "Mean", variables)
	variables <- gsub("-std\\(\\)", "StdDev", variables)
	variables <- gsub("-", "", variables)
	colnames(x_subset) <- variables
	
	# The step below creates a integer vector of subjects from the data frame sub_merged.
	subjects <- sub_merged[,1]
	
	# The steps below substitute the activity identifier with their descriptive names in
	# the data frame y_merged using the data frame activity_labels.
	activities <- activity_labels[,2][y_merged[, 1]]
	activities <- gsub("_", " ", activities)
  
	# The steps below merge the individual data frames subject, y and x in that specific order
	# to obtain the final merged data.
	data_final <- cbind(Subject=subjects, Activity=activities, x_subset)
	
	# The steps below create the subset of final merged data above by taking a mean of all
	# measurements grouped by subject and activity.
	data_tidy <- group_by(data_final, Subject, Activity) %>% summarise_each(funs(mean))
	
	# The step below is to write the data subset created above to a flat file and read it
	# back for verification.
	write.table(data_tidy, file = "data_tidy.txt", row.name=FALSE)
	data_tidy_read <- read.table("./data_tidy.txt", header=TRUE)
}