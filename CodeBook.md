#CodeBook

This describes the manipulation and summarization of data represented in tidyData.txt, written with run_analysis.R.

1. Raw data is downloaded from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
(For more information on this dataset see <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>)
2. This data is loaded into R. 
3. The test data and train data are combined to form one dataset. 
4. The standard deviation and mean of easch measurement is extracted from this set. 
5. The activities are renamed from ID (numbered 1-6) to the corresponding activity. 
6. The column names are modified using gsub to make them more easily readable. 
7. A new tidy data set is created listing the mean of each new variable from each subject and activity type. 
8. This new data set is written to "tidyData.txt".

The six activities are:

1.   WALKING
2.   WALKING_UPSTAIRS
3.   WALKING_DOWNSTAIRS
4.   SITTING
5.   STANDING
6.   LAYING

The columns listed in "tidyData.txt" are: 
- subject
- activity
- timebodyaccmagmean
- timebodyaccmagstddev
- timegravityaccmagmean
- timegravityaccmagstddev
- timebodyaccjerkmagmean
- timebodyaccjerkmagstddev
- timebodygyromagmean
- timebodygyromagstddev
- timebodygyrojerkmagmean
- timebodygyrojerkmagstddev
- freqbodyaccmagmean
- freqbodyaccmagstddev
- freqbodyaccjerkmagmean
- freqbodyaccjerkmagstddev
- freqbodygyromagmean
- freqbodygyromagstddev
- freqbodygyrojerkmagmean
- freqbodygyrojerkmagstddev
