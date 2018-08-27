library(HMDHFDplus)
library(reshape2)
setwd("C:/Users/jmaburto/Documents/GitHub/EDSD-Decomposition-Course-2018/Day 1/")

#choose a Country from HMD
XYZ <- 'DNK'
us <- "jmaburto@colmex.mx" # write your username
pw <- "kolmogorov" # write your password

# now grab death counts and population
Deaths    <- readHMDweb(XYZ,"Deaths_1x1",username=us,password=pw)
Exposures <- readHMDweb(XYZ,"Exposures_1x1",username=us,password=pw)

# select some years 
unique(Deaths$Year)
years     <- c(1991:1997)
Deaths    <- Deaths[Deaths$Year %in% years,]
Exposures <- Exposures[Exposures$Year %in% years,]

Denmark.data <- merge(Deaths,Exposures, by = c('Year','Age'))
Denmark.data <- Denmark.data[,c('Year','Age','Total.x','Total.y')]
Denmark.data <- data.table(Denmark.data)
Denmark.data <- Denmark.data[order(Year,Age)]
colnames(Denmark.data) <- c("Year","Age","Deaths","Exposures")

save(Denmark.data, file = 'R/Data_Exercise_1.RData')

### begin with the exercise for females

library(data.table)
load('R/Data_Exercise_1.RData')

#get the age-specific mortality rates
Denmark.data$mx <- Denmark.data$Deaths/Denmark.data$Exposures

#get the population structure
Denmark.data <- Denmark.data[,Nx := Exposures/sum(Exposures), by = list(Year)]

head(Denmark.data)

#get CDR by year
CDR <- Denmark.data[,list(CDR = sum(mx*Nx, na.rm = T)*1000), by = list(Year)]
CDR

# mean change from 1991 to 1997 centered in 1994
mu.bar.dot <- mean(diff(CDR$CDR))
mu.bar.dor

# get change of age specific mortality over time
mu.dot.x <- Denmark.data[, list(mu.dot = mean(diff(mx,na.rm = T),na.rm = T)), by = list(Age)]

# population structure of 1994
structure.1994 <- Denmark.data[Denmark.data$Year==1994,]$Nx

# get the average applying the structure of 1994
# This is the direct effect
direct.effect <- sum(mu.dot.x$mu.dot*structure.1994)*1000
direct.effect
Now
#get the covariance

#get the poulation growth rate
r <- Denmark.data[,list(r = mean(unlist(lapply(1:(length(Nx)-1),function(x){
  y <- log(Nx[x+1]/Nx[x])
  y
})))), by = list(Age)]

#get the change of age specific mortality rates
mean.mu.x <- Denmark.data[, list(mu.x = mean(mx,na.rm = T)), by = list(Age)]

#get the weighted average
mean.r.mu <- sum(mean.mu.x$mu.x*r$r*structure.1994, na.rm = T)*1000

#get the weighted average growth rate
mean.r    <- sum(r$r*structure.1994,na.rm = T)

#get the weighted average mortality rate
mean.mu   <- sum(mean.mu.x$mu.x*structure.1994 ,na.rm = T)

#get the covariance (compositional effect)
Compositional.effect <- mean.r.mu - mean.r*mean.mu*1000

#get total from decomposition
direct.effect + Compositional.effect



