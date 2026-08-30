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


#S4
#S3 vs S4
#Unlike S3, S4 formally enforce the object's structure

#Define the Class first
setClass(
  Class="textplot",
  
  slots = c(
    x="numeric",
    y="numeric",
    labels = "character"
  ),
  
   prototype = list(
     x=numeric(0),
     y=numeric(0),
     labels=character(0)
   ),
  
  validity=function(object){
    stopifnot(
      length(object@x)==length(object@y),
      length(object@x)==length(object@labels)
    )
    
    if(!all(nchar(object@labels)>0, na.rm = TRUE)){
      stop(
        "All labels must be missing or non zero length characters"
      )
    }
    return(TRUE)
  }
)

#Slot is defined as component of S4 object
##Give me the x slot for the S4 object - object@x

#Prototype
##Define initial default structure of an empty object eg empty numeric vector

#Validity
##Defines additional rules

#Create an object with new()
dat<-new(
  "textplot",
  x=c(1,3,5),
  y=c(1,2,4),
  labels=c("First", "Second","Third")
)
class(dat)
dat@x
dat@y
dat@labels

dat2<-new(
  "textplot",
  x=c(1,3,5),
  y=c(1,2,4),
  labels=1:3
)



dat3<- new(
  "textplot",
  x=c(1,3,5),
  y=c(1,2,4),
  labels=c("First", "Second","")
)
 

#Chapter 6 files
getwd()

chapter_path <-"chapters/chapter-06-writing-a-package"
dir.create(chapter_path,
           recursive = TRUE,
           showWarnings = FALSE)

file.create(
  file.path(chapter_path, c("README.md",
               "notes.qmd",
               "practice.R",
               "solutions.R"
              )
            )
  )


