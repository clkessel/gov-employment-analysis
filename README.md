# R Exploratory Analysis of Government Employee Data

In this code sample, we are going to explore the U.S. Government's Office of Personnel Management (OPM) FedScope Employment Cube data set from September 2022 using R.  The data set is freely available and can be found here: https://www.opm.gov/data/index.aspx.

I have the September 2022 data downloaded to a folder called 'data' in my R project folder.  I set the working directory and load the data like this:


setwd(paste(getwd(),"/data",sep=""))
getwd()
