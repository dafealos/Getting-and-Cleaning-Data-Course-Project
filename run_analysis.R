library(data.table)
library(dplyr)

#Choosing the directory

choose.dir()

#setting the directory

setwd("C:\\Users\\danielfelipe\\Documents\\Rstudio\\Coursera\\week 4\\UCI HAR Dataset")

# Reading the files

ActivityLabels <- read.table("./activity_labels.txt", header = F)

FeaturesNames <- read.table("./features.txt", header = F)

ActivityTest <- read.table("./test/y_test.txt", header = F)

ActivityTrain <- read.table("./train/y_train.txt", header = F)

FeaturesTest <- read.table("./test/X_test.txt", header = F)

FeaturesTrain <- read.table("./train/X_train.txt", header = F)

SubjectTest <- read.table("./test/subject_test.txt", header = F)

SubjectTrain <- read.table("./train/subject_train.txt", header = F)

## merging the datasets

Features <- rbind(FeaturesTest, FeaturesTrain)
Subjects <- rbind(SubjectTest, SubjectTrain)
Activities <- rbind(ActivityTest, ActivityTrain)

#rename

names(Activities) <- "Activity_number"
names(ActivityLabels) <- c("Activity_number", "Activity")

#to Get Factors the activities

ActivitiesF <- left_join(Activities, ActivityLabels, "Activity_number")[, 2]

###Rename Subjects and features
names(Subjects) <- "Subject"

names(Features) <- FeaturesNames$V2


##Creating one large Dataset from  Subjects,  ActivitiesF,  Features
Data <- cbind(Subjects, ActivitiesF)
Data <- cbind(Data, Features)


###  Means  and SD
subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
DataNames <- c("Subject", "ActivitiesF", as.character(subFeaturesNames))
Data <- subset(Data, select=DataNames)

#####Descrptive names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#### new Data with variable 
Data2 <-aggregate(. ~Subject + ActivitiesF, Data, mean)
Data2 <-Data2[order(Data2$Subject,Data2$ActivitiesF),]

#Saving the final data
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
