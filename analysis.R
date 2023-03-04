#R script to analyze government employment data
library(dplyr)
library(stringr)
library(ggplot2)
library(scales) #used for displaying continuous numbers along axis in plot
#read data into data frame
getwd()
setwd("/home/claptop/Documents/Data Science/GitHubProjects/gov-employment-analysis/data")
#read data 
emp_data <- read.csv('FACTDATA_SEP2022.TXT')

#explore data by PPGRD first before filtering
str(emp_data)
head(emp_data)
emp_data %>% select(PPGRD) %>% unique()
emp_data %>% select(PPGRD) %>% unique() %>% count()

#filter data by GS scale positions and re-examine
gs_emp_data <- emp_data %>% filter(str_detect(PPGRD,'GS'))
str(gs_emp_data)
head(gs_emp_data)
gs_emp_data %>% select(PPGRD) %>% unique()
gs_emp_data %>% select(PPGRD) %>% unique() %>% count()

#simple summary statistics
paste('Average GS salary in September 2022: ', mean(gs_emp_data$SALARY, na.rm=TRUE))
paste('Median GS salary in September 2022: ', median(gs_emp_data$SALARY, na.rm=TRUE))
paste('Total GS Civilians: ', nrow(gs_emp_data))

#barplot of GS grades and their counts
gs_emp_data %>% group_by(PPGRD) %>% summarize(total=n()) %>% ggplot(aes(x=reorder(PPGRD,total), total)) + geom_col() + scale_y_continuous(labels = comma)

#look at supervisor status
#7 different supervisor statuses...only 3 of which are designated 'Supervisor' or 'Leader'
#first, create variable to indicate sup or non-sup since there are multiple status that do this
gs_emp_data <- gs_emp_data %>% mutate(SUPSTATS = case_when(SUPERVIS == 4 | SUPERVIS == 5 | SUPERVIS == 8 | SUPERVIS == '*' ~ 'NON-SUP', SUPERVIS == 2 | SUPERVIS == 6 | SUPERVIS == 7  ~ 'SUP'))
#group & count sup & non-sup status
gs_emp_data %>% group_by(SUPSTATS) %>% summarize(total = n())
#provide ratio
num_gs_sup <- gs_emp_data %>% group_by(SUPSTATS) %>% summarize(total = n()) %>% filter(SUPSTATS == 'SUP') %>% select(total)
num_gs_nonsup <- gs_emp_data %>% group_by(SUPSTATS) %>% summarize(total = n()) %>% filter(SUPSTATS == 'NON-SUP') %>% select(total)
1/(num_gs_sup/num_gs_nonsup)


#per job type
#count gs per state


 
