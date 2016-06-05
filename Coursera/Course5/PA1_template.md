---
title: "PA1_template"
author: "Nathan Howell"
date: "May 29, 2016"
output: html_document
---
##Analysis of Movement Activity

###Loading and preprocessing the data

Show any code that is needed to

1. Load the data (i.e. read.csv())
2. Process/transform the data (if necessary) into a format suitable for your analysis


```r
library(dplyr)
library(ggplot2)
setwd("C:/Users/natehow/Coursera/Course5/")
activity <- read.csv("activity.csv",stringsAsFactors = FALSE)
activity <- tbl_df(activity)
```

###What is mean total number of steps taken per day?

For this part of the assignment, you can ignore the missing values in the dataset.

1. Calculate the total number of steps taken per day
2. If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day
3. Calculate and report the mean and median of the total number of steps taken per day


```r
bydate <- group_by(activity,date)
totalstepsperday <- summarize(bydate,totalsteps = sum(steps))
hist(totalstepsperday$totalsteps,main = "Histogram of Total Steps per Day", 
     xlab = "Steps", col = "green", breaks = 10)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)

```r
paste("The mean of the total number of steps per day is ",
      round(mean(totalstepsperday$totalsteps, na.rm = TRUE),2))
```

```
## [1] "The mean of the total number of steps per day is  10766.19"
```

```r
paste("The median of the total number of steps per day is ",
      median(totalstepsperday$totalsteps,na.rm = TRUE))
```

```
## [1] "The median of the total number of steps per day is  10765"
```

###What is the average daily activity pattern?

1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
byinterval <- group_by(activity,interval)
meaninterval <- summarize(byinterval,mean = mean(steps,na.rm = TRUE))
with(meaninterval, plot(interval,mean,main = "Average Steps by 5-min Interval"))
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)

```r
findmax <- filter(meaninterval,mean == max(mean))
paste("The interval with the highest average steps is ",findmax[1,1])
```

```
## [1] "The interval with the highest average steps is  835"
```

###Inputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
findNA <- complete.cases(activity$steps)
total <- length(activity$steps)
totalNA <- (total)-sum(findNA)
paste("1. The total number of missing values is ",totalNA)
```

```
## [1] "1. The total number of missing values is  2304"
```

```r
#I have activity and meaninterval data frames
actNA <- activity
actNA$steps <- ifelse(is.na(actNA$steps) == TRUE,
                         meaninterval$mean[meaninterval$interval %in% 
                                             actNA$interval],actNA$steps)

bydateNA <- group_by(actNA,date)
totalstepsperdayNA <- summarize(bydateNA,totalsteps = sum(steps))
totalstepsperdayNA
```

```
## Source: local data frame [61 x 2]
## 
##          date totalsteps
##         (chr)      (dbl)
## 1  2012-10-01   10766.19
## 2  2012-10-02     126.00
## 3  2012-10-03   11352.00
## 4  2012-10-04   12116.00
## 5  2012-10-05   13294.00
## 6  2012-10-06   15420.00
## 7  2012-10-07   11015.00
## 8  2012-10-08   10766.19
## 9  2012-10-09   12811.00
## 10 2012-10-10    9900.00
## ..        ...        ...
```

```r
hist(totalstepsperdayNA$totalsteps,main = "Histogram of Total Steps per Day (NAs by mean of interval)", 
     xlab = "Steps", col = "green", breaks = 10)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)

```r
paste("The mean of the total number of steps per day (NAs removed) is ",
      round(mean(totalstepsperdayNA$totalsteps, na.rm = TRUE),2))
```

```
## [1] "The mean of the total number of steps per day (NAs removed) is  10766.19"
```

```r
paste("The median of the total number of steps per day (NAs removed) is ",
      round(median(totalstepsperdayNA$totalsteps,na.rm = TRUE),2))
```

```
## [1] "The median of the total number of steps per day (NAs removed) is  10766.19"
```
The median became the mean. The mean stayed the same. Inputing missing data did nothing because you are using average values and taking the average of them so they won't change. 

###Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```r
isweekend <- function(day) {
  ifelse(day == "Saturday" | day == "Sunday","Weekend","Weekday")
}
actNA <- mutate(actNA, weekpart = isweekend(weekdays(as.POSIXct(date))))
byinterval <- group_by(actNA,weekpart,interval)
meanbyinterval <- summarize(byinterval,average = mean(steps))
a <- ggplot(data = meanbyinterval,aes(x = interval,y = average))
a <- a + geom_point()
a + facet_grid(weekpart~.)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

Yes, there are differences in weekday vs. weekend. 

Thanks for reading!
