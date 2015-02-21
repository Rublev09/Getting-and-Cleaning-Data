library(plyr)

# 1. Merge training + test datasets ---> subject_train/test datasets ----> subject_data
x_train <- read.table("train/X_train.txt")
x_test <- read.table("test/X_test.txt")
y_train <- read.table("train/y_train.txt")
y_test <- read.table("test/y_test.txt")
subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# 2. Extract Mean and SD and correct column names
features <- read.table("features.txt")
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_std]
names(x_data) <- features[mean_std, 2]

# 3. Create descriptive activity names and correct column name
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

# 4. Column name with appropriate label and create a total_data dataset (consists of 563 columns and 10299 rows)
names(subject_data) <- "subject"
total_data <- cbind(x_data, y_data, subject_data)

# 5. Independent tidy data set with the average of each variable for each activity and each subject and write file.txt
averages_data <- ddply(total_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)

