#Create Chapter 3 Folders
file.create('chapters/chapter-03-programming-automation/README.md')

#Loops
getwd()
install.packages('tidyverse', 'haven', 'purrr', 'readxl', 'openxlsx')
install.packages('tidyverse')
library(purrr)
library(haven)
library(tidyverse)

ex<-read_sas('datasets/CDISC/ex.sas7bdat')
dm<-read_sas('datasets/CDISC/dm.sas7bdat')
pc<-read_sas('datasets/CDISC/pc.sas7bdat')
pp<-read_sas('datasets/CDISC/pp.sas7bdat')
cdisc_datasets<- list(dm=dm, ex=ex, pp=pp,pc= pc)
cdisc_datasets2<- list(dm, ex, pp,pc)

for (d in cdisc_datasets) {
  print(summary(d))
}

#Modern Forloop

cdisc_datasets %>% 
  purrr::map(summary)

#Sample dataset
x<-seq(1,100000,1)
xCube<-vector("numeric", length(x))

for (i in seq_along(x)) {
  xCube[i]<-x[i]^3
}

x %>% head() %>% summary()

##Create Reference
dir.create('/references')
file.create('references/software-setup.md')
file.create('references/useful-links.md')
file.create('references/books.md')


##Break and next

#Next - SKip 5
for (i in 1:10){
  if (i==5)
    next
  print(i)
}

#Break - Don't print beyond 5
for (i in 1:10){
  if (i==5)
    break
  print(i)
}


#Generate  random
rnorm(100)

#Making i useful
set.seed(123)
for(i in 1:5){
  x<-rnorm(5,mean=4,sd=2)
  
  cat("\nSample",i,"\n")
  cat("\nXbar",mean(x),"\n")
  cat("\nStdDev",sd(x),"\n")
  
}

#i not useful
set.seed(123)
for(i in 1:5){
  x<-rnorm(5,4,2)
  print(x)
  print(paste0("Xbar: ", mean(x)))
  print(paste0("StdDev: ", sd(x)))
  
}

#Readable format - Building a dataframe

set.seed(123)
results<-data.frame(
  sample=integer(5),
  mean=numeric(5),
  sd=numeric(5)
)

for(i in 1:5){
  x<-rnorm(5,mean=4,sd=2)
  
  results$sample[i]<-i
  results$mean[i]<-mean(x)
  results$sd[i]<-sd(x)
  
}
results %>% mutate(mean=round(mean,2), sd=round(sd,2))


#Loop through datasets
#for (d in cdisc_datasets){
#  if (d==ex)
#    print(d)
#}

for (d in names(cdisc_datasets)){
  if (d=='ex'){
    print(cdisc_datasets[[d]])
  }
  
}

for (d in names(cdisc_datasets)){
  if (d=='pp'){
    View(cdisc_datasets[[d]])
  }
  
}


#While Loop
set.seed(123)
y<-3
attempt<-0
max_attempts<-10000
while(mean(y)<10 && attempt<max_attempts){
  y<-rnorm(5,4,sd=2)
  attempt<-attempt+1
}

result<-tibble(attempts=attempt,
               sample_mean=mean(y),
               sample_sd=sd(y))
result


#Flow Control

if (mean(y)>6){
  boxploy(y)
}

#If else statements
if (mean(y)>6){
  boxplot(y)
} else{
  hist(y)
}


#Next and Break
for (d in names(cdisc_datasets)){
  if(d=='ex'){
    next
  }
  cat("processing: ", d, "\n")
  print(summary(cdisc_datasets[[d]]))
}

#Break
for (d in names(cdisc_datasets)){
  if(d=='pp'){
    break
  }
  cat("processing: ", d, "\n")
  print(summary(cdisc_datasets[[d]]))
}

names(cdisc_datasets)

#apply Family of Functions
#Apply these functions to these elements
xL <- 1:5
lapply(xL, is.integer)
#Simplify
sapply(xL, is.integer)

#Expect tghe exact output structure, i.e logical value 
#Valuable for controlled programming
vapply(xL, is.integer, FUN.VALUE=NA)
vapply(xL, mean, FUN.VALUE=NA)


#Create a list
yL<-list(
  a= 1:5,
  b= c("6", "7", "8"),
  c=9:10
)

#Runs without error when it should
lapply(yL, summary)


#Defensive Programming
vapply(yL, summary, c(Min.=0,
                      '1st Qu.'=0,
                      Median=0,
                      Mean=0,
                      '3rd Qu.'=0,
                      Max.=0
                      ) 
       )

#tapply - Apply by groups

tapply(X=mtcars$mpg,INDEX=mtcars$cyl, FUN=mean)
#mODERN
mtcars %>% group_by(cyl) %>% summarise(
  mean_mpg=mean(mpg),
  .groups = "drop"
)

#Same as above
mtcars %>% group_by(cyl) %>% summarise(
  mean_mpg=mean(mpg)) %>% ungroup()

#apply, mapply rapply
apply(mtcars, MARGIN=2, FUN=sd)
apply(mtcars, 2, mean)

#rapply - e.g  travels intro nested structiures and produce means
#eapply
environment()
ls()
eapply(env=environment(), FUN=class)

#Old vs Modern
lapply(cdisc_datasets, summary)
cdisc_datasets %>% purrr::map(summary)

sapply(cdisc_datasets, nrow)
cdisc_datasets %>% purrr::map_int(nrow)
cdisc_datasets%>% purrr::map_int(nrow)

#Other modern ways
cdisc_datasets%>% purrr::map(dim)
cdisc_datasets%>% purrr::map(names)
cdisc_datasets$dm%>% names()

#Chapter 4 Files
getwd()
dir.create("chapters/chapter-04-writing-functions")
file.create("chapters/chapter-04-writing-functions/README.md",
            "chapters/chapter-04-writing-functions/notes.qmd",
            "chapters/chapter-04-writing-functions/practice.R",
            "chapters/chapter-04-writing-functions/solutions.R")

##Best practices
#Prefer vectorization where appropriate
#Preallocate objects in loops
#Use seq_along() instead of 1:length
#Use meaningful object names
#Write readable code before optimizing
#Use the tidyverse pipe (Cntrl+Shif_M) Consistently
#Automate repetitive tasks rather than copying and pasting codes


