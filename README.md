# R Exploratory Analysis of Government Employee Data

In this code sample, we are going to explore the U.S. Government's Office of Personnel Management (OPM) FedScope Employment Cube data set from September 2022 using R.  The data set is freely available as a .zip file and can be found here: https://www.opm.gov/data/index.aspx.  At the conclusion of this analysis, we hope to learn the following from the data:
1) How many General Schedule (GS) government employees are there?
2) What are the mean & median salaries of GS employees by grade?
3) What is the distribution of GS employees by grade?
4) What is the ratio of supervisor to non-supervisor employees?

I have the September 2022 data downloaded to a folder called 'data' in my R project folder.  I set the working directory, load the data, and examine its structure like this:

```
setwd(paste(getwd(),"/data",sep=""))
emp_data <- read.csv('FACTDATA_SEP2022.TXT')
str(emp_data)
```

As you will see from the above code, I am reading from the 'FACTDATA_SEP2022.TXT' file that contains the employee data, but the .zip file also contains 17 additional files.  After consulting the data dictionary (also freely available for download), these 17 additional files are referred to as Dimension Translation Files and they provide additional detail on the field values found in the 'FACTDATA_SEP2022.TXT' file.

By examining the structure of the object, we can see it is a data frame with 2,180,296 observations and 20 variables.  Since each observation represents an employee, we know the total observation equals the total number of government employees in this data set.

```
'data.frame':	2180296 obs. of  20 variables:
```

|variable    |               structure             |
|------------|-------------------------------------|
|$ AGYSUB    | chr  "AA00" "AA00" "AA00" "AA00" ...|
|$ LOC       | chr  "11" "11" "11" "11" ...|
|$ AGELVL    | chr  "F" "I" "E" "F" ...|
|$ EDLVL     | chr  "13" "15" "15" "15" ...|
|$ GSEGRD    | chr  "" "" "15" "13" ...|
|$ LOSLVL    | chr  "F" "H" "E" "E" ...|
|$ OCC       | chr  "0340" "0905" "0905" "0905" ...|
|$ PATCO     | int  2 1 1 1 1 1 2 1 2 1 ...|
|$ PP        | chr  "ES" "ES" "99" "99" ...|
|$ PPGRD     | chr  "ES-**" "ES-**" "GS-15" "GS-13" ...|
|$ SALLVL    | chr  "S" "S" "O" "L" ...|
|$ STEMOCC   | chr  "XXXX" "XXXX" "XXXX" "XXXX" ...|
|$ SUPERVIS  | chr  "2" "2" "8" "8" ...|
|$ TOA       | chr  "50" "50" "30" "30" ...|
|$ WORKSCH   | chr  "F" "F" "F" "F" ...|
|$ WORKSTAT  | int  1 1 1 1 1 1 2 1 1 2 ...|
|$ DATECODE  | int  202209 202209 202209 202209 202209 202209 202209 202209 202209 202209 ...|
|$ EMPLOYMENT| int  1 1 1 1 1 1 1 1 1 1 ...|
|$ SALARY    | int  199500 193000 158383 121065 138856 143064 203700 110384 74950 74950 ...|
|$ LOS       | num  19.3 29.7 11 13.9 10.3 8 20.5 3 1 1 ...|

### 1) How many General Schedule (GS) government employees are there?

From the structure, we notice the variable 'PPGRD', or as the data dictionary defines the "Pay Play & Grade", appears to have the information we are looking for to answer the first question, but it comes with additional PPGRD fields we don't want.  To help ourselves later on, we will fitler this data into a new data frame called gs_emp_data.  After that, a simple count gives the answer we are looking for, 1,455,584:

```
gs_emp_data <- emp_data %>% filter(str_detect(PPGRD,'GS'))
gs_emp_data %>% count()
   
1 1455584
```
### 2) What is the distribution of GS employees by grade?

Using the gs_emp_data dataframe we created in the previous step, creating a barpolot of the counts of GS employees by pay grade is fairly straight forward.  First we need to supply the dataframe we created in the previous step, then group the data by the PPGRD field, summarize by the totals in each group, then add plot method. Note: I am using the theme_economist which requires the library ggthemes.

```
gs_emp_data %>% group_by(PPGRD) %>% summarize(total=n()) %>% ggplot(aes(x=reorder(PPGRD,total), total)) + geom_col() + scale_y_continuous(labels = comma) + xlab("GS Pay Grades") + ylab("Total") +
  ggtitle("Distribution of GS pay grades Sep 2022") + theme_economist()
```

![gspaygrades_sep2022](https://user-images.githubusercontent.com/123432368/222929914-798a218c-47b1-4ea4-8fbd-76ab7fa44d30.png)


### 3) What are the mean & median salaries of GS employees in the data set?

We can easily obtain the mean and median salaries for all GS employees with the following code:

```
paste('Average GS salary in September 2022: ', mean(gs_emp_data$SALARY, na.rm=TRUE))
[1] "Mean GS salary in September 2022:  89243.2495872623"

paste('Median GS salary in September 2022: ', median(gs_emp_data$SALARY, na.rm=TRUE))
[1] "Median GS salary in September 2022:  84656"
```

However, if we want to know this level of detail for each GS pay grade, we need to group and summarize the data, similar to how we achieved the barplot in the previous answer.  This code would look like this:
```
gs_emp_data %>% group_by(PPGRD) %>% summarize(mean=mean(SALARY, na.rm=TRUE), median=median(SALARY, na.rm=TRUE))
```

And our results will look like this:

|  PPGRD |  mean  | median|
|--------|--------|-------|
|<chr>   |<dbl>   | <dbl> |
|1 GS-** |    NaN |     NA|
|2 GS-01 | 31402. |  31305|
|3 GS-02 |  32745.|  31931|
|4 GS-03 |  34251.|  32570|
|5 GS-04 |  36835.|  35889|
|6 GS-05 |  41968.|  40883|
|7 GS-06 |  49429.|  47614|
|8 GS-07 |  53417.|  52195|
|9 GS-08 |  60745.|  59937|
|10 GS-09|  65196.|  63848|
|11 GS-10|  75407.|  72426|
|12 GS-11|  79393.|  77715|
|13 GS-12|  97103.|  95541|
|14 GS-13| 118528.| 117505|
|15 GS-14| 143277.| 143064|
|16 GS-15| 168243.| 173232|

As you may have noticed, the 'GS-**' pay grade returns NaN and NA for the mean and median values, respectively.  A closer examination of that data reveals that the 127 entries for that pay grade contain only 'NA' for salary.

### 4) What is the ratio of supervisor to non-supervisor employees?

To answer our last question, we need to dig into the data dictionary a little bit.  From examining the structure of our initial data, we can see that there is a 'SUPERVIS' column that seems like a good place to start:
  ```
  $ SUPERVIS  : chr  "2" "2" "8" "8" ...
  ```
  Upon consulting the data dictionary, we can see that this column represents the Supervisory Status data element and contains 7 possible values.  For the purposes of this example,  we will use Supervisory Statuses of 4,5,8, and * to represent non-supervisory positions while the remaining three codes of 2, 6, and 7 represent a supervisory position.  First we update our data set to translate these codes into a value that indicates 'Non-Sup' or 'Sup':
  ```
 gs_emp_data <- gs_emp_data %>% mutate(SUPSTATS = case_when(SUPERVIS == 4 | SUPERVIS == 5 | SUPERVIS == 8 | SUPERVIS == '*' ~ 'NON-SUP', SUPERVIS == 2 | SUPERVIS == 6 | SUPERVIS == 7  ~ 'SUP'))
  ```
Then group and summarize by our newly created variable:
  ```
  gs_emp_data %>% group_by(SUPSTATS) %>% summarize(total = n())
  ```
|SUPSTATS  | total|
|----------|------|
|1 NON-SUP | 1274716|
|2 SUP     | 180868|

Using this approach, this equates to roughly 1 supervisor for every 7 employees.

## I hope you enjoyed this brief look at U.S. Government Employee data, please see the analysis.R file for the complete code. Thanks!
