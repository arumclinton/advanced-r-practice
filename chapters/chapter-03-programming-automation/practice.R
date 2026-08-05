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
cdisc_datasets<- list(dm, ex, pp, pc)

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



