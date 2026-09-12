#Chapter 8 - Data Munging with Data.Table  
#..........................................
# =================================================================
# CHAPTER 8
# data munging with data.table 
#=====================================================================


#Read in Data and Inspect

library(tidyverse)
d<-haven::read_sas(
  "datasets/sas/nschpuf3.sas7bdat"
) %>% 
  data.table::as.data.table()


data.table::setkey(
  d,
  IDNUMR
)

#Inspect the Structure of dataset 
names(d)
str(
  d,
  give.attr=FALSE,
  strict.width="cut",
  list.len=20
)

table(d[, EDUCATIONR])
table(d[, PLANGUAGE])
table(d[, BMICLASS])
table(d[, S1Q01])



#==========================================================
#Regular Expressions:grep() and grepL()
#==========================================================

x<-c(
  "a",
  "abc",
  "def",
  "abc",
  "d"
)


grep(
  pattern = "abc",
  x=x
)



grepl(
  pattern = "abc",
  x=x
)


x<-c(
  "1 - REFUSED TREATMENT",
  "2 - DID NOT REFUSED TREATMENT",
  "3 - REFUSED"
)

grep(
  pattern="REFUSED",
  x=x,
  value=TRUE
)


#Only those starting with Refused
grep(
  pattern="- REFUSED",
  x=x,
  value=TRUE
)

#Actual Code with Refused
grep(
  pattern="REFUSED$",
  x=x,
  value=TRUE
)

# $ Must end with Refused
grep(
  pattern="- REFUSED$",
  x=x,
  value=TRUE
)
# $ Means End of String


#Match One or More Digits

x<-c(
  "1 - TREATMENT REFUSED TREATRMENT",
  "2 - DID NOT REFUSED TREATMENT",
  "3 - JACK - REFUSED",
  "4 - REFUSED",
  "97 - REFUSED",
  "- REFUSED"
)

#Any digit from 0-9 plus 1 or More of the preceding pattern
#0-9+ (Means one or more digits) but not a blank
grep(
  pattern = "[0-9]+ - REFUSED$",
  x = x,
  value = TRUE
)




x<-c(
  "1 - TREATMENT REFUSED TREATRMENT",
  "2 - DID NOT REFUSED TREATMENT",
  "3 - JACK - REFUSED",
  "4 - REFUSED",
  "97 - REFUSED",
  "-97 - REFUSED",
  "- REFUSED",
  "TRICK CASE 4 - REFUSED"
)


grep(
  pattern = "^[-]*[0-9]+ - REFUSED$",
  x = x,
  value = TRUE
)


#^ = Begnning of a string
#[-]* Zero or more minus signs
#


#Testing with OR

x<-c(
  "1 - TREATMENT REFUSED TREATRMENT",
  "2 - DID NOT REFUSED TREATMENT",
  "3 - JACK - REFUSED",
  "4 - REFUSED",
  "97 - REFUSED",
  "-97 - REFUSED",
  "-2 - MISSING",
  "- REFUSED",
  "TRICK CASE 4 - REFUSED"
)


grep(
  pattern = "^[-]*[0-9]+ - REFUSED$|MISSING$",
  x = x,
  value = TRUE
)


#Pattern
p<-"^[-]*[0-9]+ - REFUSED$|MISSING$|DON'T KNOW$|LEGITIMATE SKIP$|PARTIAL INTERVIEWS$|NOT IN UNIVERSE$"
v<-c(
  "EDUCATIONR",
  "PLANGUAGE",
  "BMICLASS",
  "S1Q01",
  "S2Q01"
)

d[,(v) :=lapply(.SD, function(x){
  x[grepl(pattern=p, x)]<-NA
  if(is.factor(x)) droplevels(x) else x
}), .SDcols = v]



d[,(v) :=lapply(.SD, function(x){
  x[grepl(pattern=p, x)]<-NA
  if(is.factor(x)) droplevels(x) else x
}), .SDcols = v]

table(d[, EDUCATIONR])
table(d[, S1Q01])
table(d[, BMICLASS])


class(d$EDUCATIONR)
head(d$EDUCATIONR)
levels(d$EDUCATIONR)

unique(d$EDUCATIONR)
table(d$EDUCATIONR, useNA = 'ifany')
table(d$PLANGUAGE, useNA = 'ifany')
table(d$BMICLASS, useNA = 'ifany')
table(d$S1Q01, useNA = 'ifany')
attributes(d$S1Q01)
attr(d$S1Q01, "label")


unique(d$EDUCATIONR)
unique(d$BMICLASS)
unique(d$PLANGUAGE)
unique(d$S1Q01)


view(d)
#Identify Coded Missing responses and turn to NA
#Recod ecoded missing values to R's NA

d[
  EDUCATIONR %in% c(96,97),
  EDUCATIONR := NA_integer_
]


d[
  PLANGUAGE %in% c(6,7),
  PLANGUAGE := NA_integer_
]


d[
  BMICLASS %in% c(),
  BMICLASS := NA_integer_
]


d[
  S1Q01 %in% c(6, 7),
  S1Q01 := NA_integer_
]

#Check if above applied
unique(d$PLANGUAGE)
unique(d$EDUCATIONR)
unique(d$BMICLASS)
unique(d$S1Q01)


#Use gsub() to remove numeric prefix from labelled strings

gsub(
  pattern="abc",
  replacement="",
  x=c(
    "a",
    "abcd",
    "123abc456"
    
  )
)

#Removing Numeric Prefix

p.remove<-"^[-]*[0-9]+ -"

gsub(
  pattern=p.remove,
  replacement ="",
  x=c(
    "1 - TREATMENT REFUSED",
    "-97 - REFUSED",
    "-2 - NOT IN UNIVERSE",
    "- REFUSED",
    "TRICK CASE 4 - REFUSED"
  )
)


# %between%  function

library(data.table)
x<-c(12, 1, 3, 5, 10, 15)
x %between% c(1,10)
!(x %between% c(1,10))


#Applying to S2Q02R
#Which ROWS and What Columns
table(
  d[
    !S2Q02R%between%c(0,90),
    S2Q02R
  ]
)


table(
  d[
    !S2Q03R%between%c(0,900),
    S2Q03R
  ]
)



#Distribution
class(d$S2Q03R)
class( d[, (S2Q02R)])
hist(
  d[, (S2Q03R)]
  
)


hist(
  d[, (S2Q02R)]
  
)


# Numeric Coding - Define Variables and Candidate Linits
v2<-c(
  "S2Q02R",
  "S2Q03R",
  "AGEYR_CH"
)

#There Possible Upper limits
m<-sort(
  c(
    9,
    99,
    999
  )
)




#Creating New Variables
#Creating a list of health condition Variables
v.health<-paste0(
  "S2Q",
  c(19,20,21,22,23,24,26,35,37)
)

#Check responses across the nine variables
table(
  unlist(
    d[, v.health, with =FALSE]
  )
)

#Recode 6 and 7 to NA
d[
  ,
  (v.health):=lapply(.SD,function(x){
    x[x %in% c(6,7)] <-NA_real_
    x
  }),
  .SDcols = v.health
]

#Checking i fthe function worked
table(
  unlist(
    d[, v.health, with =FALSE]
  ),
  useNA = "ifany"
)

class(d$S2Q19)
table(d$S2Q19)
View(d$S2Q19)


#Calculate yes for each component ; No of YES/No of Valid responses
#rowMeans Calculates the mean across columns for each individual rows

d[
  ,
  HealthConditions:=rowMeans(
    d[, v.health, with=FALSE]==1,
    na.rm=TRUE
  )
]

#Inspect the results
table(
  round(d$HealthConditions, 2),
  useNA = "ifany"
)

#Misleading counts about NAs -Returns as0
#Checking NAs
d[
  ,
  NMissHealthConditions:=rowSums(
    is.na(
      d[, v.health, with=FALSE]
    )
  )
]

length(v.health)
d[
  NMissHealthConditions==length(v.health),
  NHealthConditions:=NA_integer_
]

#Inspect
table(
  d$NMissHealthConditions,
  useNA = "ifany"
)


#Check to see if th e6 NA values were acrtually convested
sum(is.nan(d$HealthConditions))#Counts NaN
sum(is.na(d$HealthConditions)) #Counts both NA and NaN

#Changing NaN to NA
d[
  is.nan(HealthConditions),
  HealthConditions:=NA_real_
]
sum(is.nan(d$HealthConditions))
sum(is.na(d$HealthConditions))

d[
  ,
  NHealthConditions:=rowSums(
    d[, v.health, with=FALSE]==1,
    na.rm = TRUE
  )
]

table(
  d$NHealthCondition,
  useNA = "ifany"
)

#NA the missing condirtions
d[
  ,
  NMissHealthConditions:=rowSums(
    is.na(d[, v.health, with=FALSE])
  )
]

#Inspect
table(
  d$NMissHealthConditions,
  useNA = "ifany"
)

#No NA so correction - So we will See NA values
d[
  NMissHealthConditions==length(v.health),
  NHealthConditions:=NA_integer_
]

table(
  d$HealthConditions,
  useNA = "ifany"
)
#Understanding Reduce()
#Reduce - Repeatedy appy operation
Reduce("+", c(1,2,3))
Reduce(
  "+",
  list(1:3,
       4:6,
       7:9
       )
       )
#Can also do division(/) amd power ^


#=========================================================
#FUZZY MATCHING
#=========================================================

reference.Names<-c(
  "This Test",
  "Test Thas",
  "Jane Mary",
  "Jack Dun-Dee"
)

observed.Names<-c(
  "this test",
  "test this",
  "test that",
  "JaNe Mary.",
  "Mary Sou",
  "Jack Dee",
  "Jane Jack"
)


#Calculating String Distance
library(stringdist)
stringdist::stringdistmatrix(
  reference.Names,
  observed.Names,
  method="dl"
)
#dl - Damerau-Levenshtein distance - Appr how many character edits are required to transform on estring to another

#Closest match with amatch()
stringdist::amatch(
  observed.Names,
  reference.Names,
  
  method="dl",
  maxDist=4
)


#Ignore Capitalization
stringdist::stringdistmatrix(
  tolower(reference.Names),
  tolower(observed.Names),
  method="dl"
)

#Remove Punctuation
stringdist::stringdistmatrix(
  tolower(
    gsub("\\.", "", reference.Names)
    ),
  tolower(
    gsub("\\.", "", observed.Names)
    ),
  method="dl"
)

#Using strsplit
strsplit(
  x=reference.Names[1],
  split = "\\s"
)[[1]]
#[[1]] Returns First element -Extracts what is inside
#[1] Keeps the container

#MatchIt() Function - SKIP THis - TO develop later 
#Removes unwanted characters, lower casing, optional splitting, calculate string distance, identify exact vs uncertain matches

 #system("git add chapters/chapter-08-data-munging/Practice.R renv.lock")
#system('git commit -m "Complete Chapter 8 Excercise - Data Munging"')
#system("git push")
#system("git status")

#Create Chapter  09 Files
#Create Chapter 9 Branch
#system("git switch -c feature/chapter-09-dplyr-data-management")

system("git branch --show-current")
