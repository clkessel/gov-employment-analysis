#R script to analyze government employment data
library(dplyr)
library(stringr)
library(ggplot2)
library(scales)

setwd(paste(getwd(),"/data",sep=""))

#read data 
emp_data <- read.csv('FACTDATA_SEP2022.TXT')
 
#explore data by PPGRD first before filtering
str(emp_data)
head(emp_data)

emp_data %>% select(PPGRD) %>% unique()
emp_data %>% select(PPGRD) %>% unique() %>% count()
emp_data %>% filter(str_detect(PPGRD,'GS')) %>% count()

#filter data by GS scale positions and re-examine
gs_emp_data <- emp_data %>% filter(str_detect(PPGRD,'GS'))

#For question 1: How many General Schedule (GS) government employees are there?
gs_emp_data %>% count()

#For question 2: What are the mean & median salaries of GS employees by grade?
paste('Mean GS salary in September 2022: ', mean(gs_emp_data$SALARY, na.rm=TRUE))
paste('Median GS salary in September 2022: ', median(gs_emp_data$SALARY, na.rm=TRUE))
paste('Total GS Civilians: ', nrow(gs_emp_data))
#mean & median for each pay grade
gs_emp_data %>% group_by(PPGRD) %>% summarize(mean=mean(SALARY, na.rm=TRUE), median=median(SALARY, na.rm=TRUE))

#For question 3: What is the distribution of GS employees by grade?
#barplot of GS grades and their counts
library(ggthemes)
gs_emp_data %>% group_by(PPGRD) %>% summarize(total=n()) %>% ggplot(aes(x=reorder(PPGRD,total), total)) + geom_col() + scale_y_continuous(labels = comma) + xlab("GS Pay Grades") + ylab("Total") +
  ggtitle("Distribution of GS pay grades Sep 2022") + theme_economist()

#For question 4: What is the ratio of supervisor to non-supervisor employees?
gs_emp_data <- gs_emp_data %>% mutate(SUPSTATS = case_when(SUPERVIS == 4 | SUPERVIS == 5 | SUPERVIS == 8 | SUPERVIS == '*' ~ 'NON-SUP', SUPERVIS == 2 | SUPERVIS == 6 | SUPERVIS == 7  ~ 'SUP'))
#group & count sup & non-sup status
gs_emp_data %>% group_by(SUPSTATS) %>% summarize(total = n())
#provide ratio
num_gs_sup <- gs_emp_data %>% group_by(SUPSTATS) %>% summarize(total = n()) %>% filter(SUPSTATS == 'SUP') %>% select(total)
num_gs_nonsup <- gs_emp_data %>% group_by(SUPSTATS) %>% summarize(total = n()) %>% filter(SUPSTATS == 'NON-SUP') %>% select(total)
num_gs_sup/num_gs_nonsup
1/(num_gs_sup/num_gs_nonsup)


