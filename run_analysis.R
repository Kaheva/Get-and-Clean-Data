# Load all required files in "environment"
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("no", "feature"))
labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("number", "activity"))
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "number")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "number")
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("no", "activities"))

# Combine all "train" data sets with their corresponding test data sets
x_combined <- rbind(x_train, x_test)
y_combined <- rbind(y_train, y_test)
subject_combined <- rbind(subject_train, subject_test)

# Combine all of the different data sets together
full_data_combined <- cbind(subject_combined, y_combined, x_combined)
head(full_data_combined)

# Compile only mean and standard deviation measurements, along with subject & columns numbers
mean_std_data <- full_data_combined[,grep("subject|number|std|mean", colnames(full_data_combined))]

# Use names for the activities, instead of numbers 
mean_std_data$number <- activities[mean_std_data$number, 2]

# Change column names from abbreviation to full names
names(mean_std_data)[1] = "Subject"
names(mean_std_data)[2] = "Activity Performed"
names(mean_std_data)<-gsub(".", " ", names(mean_std_data), fixed = TRUE)
names(mean_std_data)<-gsub("bodybody", "Body", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("tbody", "Time Body", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("fbody", "Freq Body", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("std", "Std Dev", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("mean", "Mean", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("acc", " Accelerometer", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("gyro", " Gyroscope", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("mag", " Magnitude", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("gravity", " Gravity", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("angle", " Angle", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("jerk", " Jerk", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("t ", "Time ", names(mean_std_data), ignore.case = TRUE)

# Store clean data set, with with the average of each variable for each activity and each subject, in a separate .txt file
library(dplyr)

clean_data <- mean_std_data %>% group_by(Subject, `Activity Performed`) %>% summarise_all(funs(mean))
write.table(clean_data, "CleanDataSet.txt", row.name=FALSE)