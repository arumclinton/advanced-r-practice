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