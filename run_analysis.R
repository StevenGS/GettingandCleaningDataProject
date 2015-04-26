library(plyr)
# read data
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjecttrain <- read.table("train/subject_train.txt")

xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjecttest <- read.table("test/subject_test.txt")

# combine 'x' data set
xdata <- rbind(xtrain, xtest)

# combine 'y' data set
ydata <- rbind(ytrain, ytest)

# combine 'subject' data set
subjectdata <- rbind(subjecttrain, subjecttest)

features <- read.table("features.txt")

# get only columns with mean() or std() in names
meanStdFeatures <- grep("-(mean|std)\\(\\)", features[, 2])

# subset columns
xdata <- xdata[, meanStdFeatures]

# correct column names
names(xdata) <- features[meanStdFeatures, 2]

activities <- read.table("activity_labels.txt")

# update values with correct activity names
ydata[, 1] <- activities[ydata[, 1], 2]

# correct column name
names(ydata) <- "activity"

# correct column name
names(subjectdata) <- "subject"

# combine data
alldata <- cbind(xdata, ydata, subjectdata)

# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject


tidydata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidydata, "tidydata.txt", row.name=FALSE)