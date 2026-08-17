#Writing functions
#CHAPTER 4
#INPUT > FUNCTION > PROCESSING > OUTPUT

#Mean Function
x<- c(10, 20, 30)
mean(x)



#4.1 Loops
install.packages('tidyverse', 'haven', 'purrr', 'readxl', 'openxlsx')
library(purrr)
library(haven)
library(tidyverse)
ex<-read_sas('datasets/CDISC/ex.sas7bdat')
dm<-read_sas('datasets/CDISC/dm.sas7bdat')
pc<-read_sas('datasets/CDISC/pc.sas7bdat')
pp<-read_sas('datasets/CDISC/pp.sas7bdat')
adsl<-read_sas('datasets/admiral/adsl.sas7bdat')
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


#Scoping
plot<-5+2
graphics::plot(1:5)

#attached environments/Packages
#R uses the environment where a function was defined, not simple wherever the function happens to be called

search()

#Three types of variables
a<-'free variable'
f<-function(x='formal variable'){
  y<-'local variable'
  
  print(a)
  print(x)
  print(y)
}
f()

#f1()/f2() Example
f1<-function(y="f1 var"){
  x<-y
  a1<-f2(x)
  rm(x)
  a2<-f2(x)
}
#f2
f2<-function(x){
  
  if(nchar(x)<10){
    x<- "f2 local var"
    
  }
  print(x)
  return(x)
}

f1()




#Clinical Programming Perspective
usubjid_pre<-"01-701-1015"
process_adsl<-function(adsl){
  adsl %>% filter(USUBJID==usubjid_pre)
}
process_adsl(adsl)

#MOre robust
process_adsl<-function(adsl, usubjid_pre){
  adsl %>% filter(USUBJID==usubjid_pre)
}
process_adsl(adsl,"01-701-1015")

View(adsl)

#Functions for Function

#match.arg() - Restrict valid choices
f<-function(type=c("first", "Second")){
  type=match.arg(type)
  type
}
f("first")
f("test")

calculate_stat<-function(x,statistic=c("mean","median","sd")){
  statistic<-match.arg(statistic)
  
  if(statistic=="mean"){
    mean(x)
      }else if(statistic=="median"){
        median(x)
          }else {
            sd()
          }
        }
    
calculate_stat(1:20, "mean") 
#Validate Choices early
calculate_stat(1:20, "variance")


#Handling Missing = Was an argument Supplied
describe_values<-function(x,label){
  if(missing(label)){
    label<-"Unlabelled"
  }
    paste(label, "Mean=", mean(x))
  }

describe_values(1:20)
describe_values(1:20, label= "age")

#Match.call - Prints teh same call in the results section/console
#Retaining information abput how analysis was performed
fcall<-match.call()
my_mean<-function(x, na.rm=FALSE){
  call<-match.call()
  result<- mean(x, na.rm=na.rm)
  list(result=result,call=call)
}
my_mean(1:10, na.rm=TRUE)
model<-lm(mpg~hp, data=mtcars)

#Return = What comes out?
add_numbers <- function(x,y){
  x+y
}
add_numbers(5,2)

#Explicit
add_numbers <- function(x,y){
  return(x+y)
}
add_numbers(5,5)


#Early Return
f<- function(x){
  if(x<4){
    return("I'm done")
  }
  paste(x,"-Fin!")
}
f(2)
f(5)

#Invisible - Return Something without Printing It
f<-function(x){
  invisible(x*2)
}
f(2)
result<-f(2)

#On.exit() - Clean up even when something fails
f<-function(x){
  on.exit(print("Game over"))
  x+5
}
f("a")

#Not qUITE cLEAR - tO REVIEW
my_function<-function(){
  old_option<-getOption("Width")
  on.exit(
    options(width=old_option))
  options(width=100)
}
my_function()


#Stop(), warning(), and message()
#Clinical examples

check_age <- function(data){
  if(!"AGE" %in% names(data)){
    stop("Age variable missing from the dataset.")
  }
  if(any(data$AGE<0, na.rm=TRUE)){
    stop("AGE Contains negative values")
  }
  if(anyNA(data$AGE)){
    warning("AGE contains missing values")
  }
  message("Age validation completed successfu;;y")
}
check_age(adsl)
check_age(dm)
check_age(ex)

##DEBUGGING section
#meanPlot Example

meanplot<-function(formula, d){
  v<-all.vars(formula)
  m<-tapply(d[, v[1]],
            d[,v[2]],
            FUN=mean,
            na.rm=TRUE
            )
  plot(formula, data=d, type="p")
  points(
    x=unique(d[,v[2]]),
    y=m,
    col='blue',
    pch=16,
    cex=2
  )
  
}
meanplot(mpg~cyl, d=mtcars)

#Debug through a function
debug(meanplot)
meanplot(mpg~cyl, d=mtcars)

#Stop Debugging
Q

#Browse - Deliberately Pause inside your function
meanplot<-function(formula, d){
  v<-all.vars(formula)
  d<-d[order(d[, v[2]]),]# Sort first - Without this get error
  
  m<-tapply(d[, v[1]],
            d[, v[2]],
            FUN=mean,
            na.rm=TRUE
  )
  browser()
  
  plot(formula, data=d, type="p")
  
  
}
meanplot(mpg~cyl, d=mtcars)
mtcars[, v[1]] # Dont work because it is outside a function


#Traceback() - What led to the error
lm(mpg~jack, d=mtcars)
traceback()

#Check age example - Debug
check_age <-function(x){
  if(any(x<0, na.rm=TRUE)){
    stop("Age cannot be negative")
  }
  mean(x,na.rm=TRUE)
}
check_age(C(23, -5, 17))

#Debug
debug(check_age)
check_age(C(23, -5, 17))


#Set up fOR Chapter 5
getwd()
chapter_path<-"chapters/chapter-05-writing-classes-methods"
dir.create(chapter_path, 
           recursive = TRUE, 
           showWarnings = FALSE
           )

file.create(
  file.path(chapter_path, 
            c("README.md",
              "practice.R",
              "solutions.R",
              "notes.qmd"
              )
            )
  )
list.files(chapter_path)


