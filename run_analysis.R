# PLEASE, MAKE SURE YOU HAVE THE DATA IN YOUR WORKING DIRECTORY BEFORE YOU START

setwd("C:/Datos_Nuevos/Cursos/Data Science Specialization/3. Obtaining and Cleaning Data/final/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

# 1. Merges the training and the test sets to create one data set.

# features contains the names of the variables
features <- read.table("features.txt")

# here we load the activity labels
act_lab <- read.table("activity_labels.txt")

# Now we load the train data
train <- read.table("train/X_train.txt", col.names = features$V2) # We use features to name the columns here. I'm not sure, but I think
# this is what we should do in question 4: "Appropriately labels the data set with descriptive variable names.". If that's wrong,
# well, my bad.
trainlab <- read.table("train/y_train.txt") # this is the activity labels for the train dataset
trainsub <- read.table("train/subject_train.txt") # this is the subject for the train dataset
train$subject <- trainsub$V1 # We add the subject information to the train data set
train$activity <- trainlab$V1 # the same with the activity labels

# Here we follow the same process with the test data
test <- read.table("test/X_test.txt", col.names = features$V2) # The same here: I think I'm doing point 4 by labeling the variables this way
testlab <- read.table("test/y_test.txt")
testsub <- read.table("test/subject_test.txt")
test$subject <- testsub$V1
test$activity <- testlab$V1

# Now we match both datasets with rbind(). We do not use merge because the subjects are different in each data base, so we
# only need to do an rbind()
data <- rbind(train, test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# I considered that all variables that contained the words "[Mm]ean" or "std" will be considered. I use the index vector that grep()
# gives you to subset the data. The 562 and 563 columns are the ones we added: subject and activity labels.
finaldata <- data[,c(grep("[Mm]ean|std", names(data)),562,563)]

# 3. Uses descriptive activity names to name the activities in the data set

# We change the activity variable to show the activity label, not is number code. So we need to transform it into a 
# factor variable, we establish the levels and labels with the activity labels data set: act_lab
finaldata$activity <- factor(finaldata$activity, levels = act_lab$V1, labels = act_lab$V2)
# Now, if you want to see this variable you will see the labels, not the number code

# 4. Appropriately labels the data set with descriptive variable names.
# Already done this in question 1.

# 5. From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.

library(reshape2)

# We need for each subject the means for each activity, so we need to melt the data
meltfinaldata <- melt(finaldata, id = c("subject", "activity"), measure.vars = names(prueba)[1:86])

# to calculate the means, we use dcast() by two variables: subject + activity
meandata <- dcast(meltfinaldata, subject + activity ~ variable, mean)

#we write the data into a text file
write.table(meandata,"meandata.txt", row.name = FALSE)

