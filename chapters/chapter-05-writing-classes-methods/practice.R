##Writing Classes and Methods
#Examples - Numeric, character, logical, data.frame, Date
library(tidyverse)
library(ggplot2)
summary(1:10)
base::summary(1:10)
summary(as.factor(c("a", "b", "c", "a", "c", "a")))

#Method - Describes - What should this function do when it receives this particular class?

class(mtcars)
  summary(mtcars)
model<-lm(mpg~hp, d=mtcars)  
summary(model)
plot(model)
print(model)
predict(model)

#Check Re3v exist and install if not

print.my_class(model)

#Prerequisite 
objects<-list(
  number=5, 
  text="Advanced R",
  logical=TRUE,
  vector=1:10,
  factor=factor(c("A", "B", "C")),
  data=mtcars,
  date=Sys.Date(),
  model=lm(mpg~hp, d=mtcars)
)
objects %>% 
  purrr::map(class)


##S3
#Simplest Idea
#S3 Class and Inheritance

person<-list(name="clinton",
             age=40)
class(person)<-"person"
class(person)

person<- data.frame(
  name<-c("Dirsty", "Peppa","Patrick" ),
  age<-c(27,30,36)
)
class(person)<-c("person", "data.frame")
class(person)

#Create an S3 Method
print.person<-function(x, ...){
  cat("Name:", x$name, "\n")
  cat("Age:", x$age, "\n")
}
print(person)



#Methods() lets you inspect the system
methods(print)
methods(plot)

#UseMethod() - the engine behind S3
#UseMethod tells R - Look at the class of the object and find the appropriate plot.* method
plot
plot(person)

#:: vs :::
#Public Exported Function
dplyr::filter

#Non exported internal Function
graphics:::plot.table#Give me the internal  plot.table function from graphics

#Clinical Programming Connection

adsl_info<-list(
  dataset="ADSL",
  subjects=120,
  treatment_groups=c("Placebo", "Treatment")
)
class(adsl_info)<-"adsl_info"

#Now we create
print.adsl_info<-function(x, ...){
  cat("Dataset:", x$dataset, "\n")
  cat("Subjects:", x$subjects, "\n")
  cat("Treatment groups:", paste(x$treatment_groups, collapse = ", ") , "\n")
}

print(adsl_info)
methods(print)
print
UseMethod("print")
