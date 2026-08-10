#Create Chapter 3 Folders
file.create('chapters/chapter-03-programming-automation/README.md')

#Loops
getwd()
install.packages('tidyverse', 'haven', 'purrr', 'readxl', 'openxlsx')
install.packages('tidyverse')library(purrr)
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
##Best practices
#Prefer vectorization where appropriate
#Preallocate objects in loops
#Use seq_along() instead of 1:length
#Use meaningful object names
#Write readable code before optimizing
#Use the tidyverse pipe (Cntrl+Shif_M) Consistently
#Automate repetitive tasks rather than copying and pasting codes


