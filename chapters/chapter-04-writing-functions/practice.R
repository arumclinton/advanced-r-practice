#Writing functions
#INPUT > FUNCTION > PROCESSING > OUTPUT

#Mean Function
x<- c(10, 20, 30)
mean(x)



#Loops
install.packages('tidyverse', 'haven', 'purrr', 'readxl', 'openxlsx')
library(purrr)
library(haven)
library(tidyverse)
ex<-read_sas('datasets/CDISC/ex.sas7bdat')
dm<-read_sas('datasets/CDISC/dm.sas7bdat')
pc<-read_sas('datasets/CDISC/pc.sas7bdat')
pp<-read_sas('datasets/CDISC/pp.sas7bdat')
cdisc_datasets<- list(dm=dm, ex=ex, pp=pp,pc= pc)
cdisc_datasets2<- list(dm, ex, pp,pc)



#Mean Function
mean(x)
calculation_mean<-function(x){
  mean(x)
}
calculation_mean(c(10, 15, 20))

#Simulation
y<-rnorm(n=5,mean=4, sd=2)
mean(y)
sd(y)

#Self function
simulate_sample<-function(n, population_mean, population_sd){
  x<-rnorm(n, mean=population_mean, sd=population_sd
           )
  
  tibble(sample_mean=mean(x),
         sample_sd=sd(x)
         )
}

#Random numbers - Dont run without return
simulate_sample2<-function(n, population_mean, population_sd){
  z<-rnorm(n, mean=population_mean, sd=population_sd
  )
  return(z)
}

simulate_sample2(n=5,population_mean= 4, population_sd=2)
simulate_sample(n=5,population_mean= 4, population_sd=2)


#Automation
1:100 %>% 
  purrr::map_dfr(
    ~simulate_sample(
      n=5,population_mean=4,population_sd=2
    )
  )

1:3 %>% purrr::map_dfr(
  ~simulate_sample(
    n=5,population_mean=4,population_sd=2
  )
)


#Repetitive task
dim(ex)
names(ex)
summary(ex)

dim(dm)
names(dm)
summary(dm)

#Function equivalent
inspect_data<-function(data){
  list(dim=dim(data),
       var=names(data)
     
       )
}
inspect_data(ex)

#Automation
cdisc_datasets %>% purrr::map(inspect_data)

#Defaults
f<-function(x, y=2){
  x+y
}

f(3)
f(3,60)


#Check how function should be called - Components of a function
args(f)
args(mean)
args(read.csv)
body(f)
body(mean)
formals(f)
formals(inspect_data)
environment(f)
environment(install.packages)
environment(dplyr::filter)


#Scooping
