  getwd()
#Chapter 7 - Data Management  
#..........................................
# =================================================================
# CHAPTER 7
# INTRODUCTION TO DATA MANAGEMENT USING data.table
#=====================================================================
library(data.table)
packageVersion("data.table")  
# DT[i, j, by]

#Control printing and display options
options(
  stringsAsFactors=FALSE,
  datatable.print.nrows = 20,
  datatable.print.topn = 3,
  digits=2
)

#Create First Data table
#Species from Factor to character
iris$Species<-as.character(
  iris$Species
)


#Convert iris data.frame
diris<-data.table::as.data.table(
  iris
)

class(diris)
nrow(diris)
ncol(diris)
tables()
data.table::tables()

#Inspect columns
sapply(diris, class)
data.table::haskey(diris)
data.table::setkey(diris, Species)
data.table::key(diris)


#Ordering a data table
diris<-diris[order(Sepal.Length)]

#RESET THE SPECIES KEYS
##==============================================================#
# 4. KEYS AND DUPLICATES
##===============================================================#
#RESET Specis as key
#It also sorts by Species
data.table::setkey(
  diris,
  Species
)

#Confirm the key
data.table::key(diris)

#Confirm that key exists
data.table::haskey(diris)

anyDuplicated(diris)
diris[141:145]
anyDuplicated(
  diris$Sepal.Length
  )
diris[5:8]


anyDuplicated(
  diris$Sepal.Width
)

diris[6:10]

table(
  duplicated(diris)
)

data.table::key(diris)
unique(diris)




#===============================================================================#
# 5. SELECTING AND SUBSETTING DATA
#================================================================================#

#Selecting Rows by position/Excludin
diris[1:5]
diris[-(1:148)]

#DSelecting using keys
diris["Petal.Width"]
diris["setosa"]
diris[!"setosa"]

#Logical Filtering
#We dont need $ Inside the box
diris[Sepal.Length > 5]
#We can use & and |(or)
diris[Sepal.Length == 4.3 | Sepal.Length==4.4]

#####%n% 
interest<-c(4.3, 4.4)
#library(tidyverse)
diris[Sepal.Length %in% interest]

#We could also use Not in with 
diris[!Sepal.Length %in% interest]

#===============================================================================#
# Variable Renaming and Column Ordering
#===============================================================================#

#---------------------------------------------
# View Column names
#---------------------------------------------

names(diris)
names(iris)
colnames(diris)

#Rename a column with Setnames
data.table::setnames(
  diris,
  old="Sepal.Length",
  new="SepalLength"
  )

#Rename using column position
data.table::setnames(
  diris,
  old=1,
  new="SepalL"
)


#Reorder the Columns
data.table::setcolorder(
  diris,
  c(
    "SepalL", 
    "Petal.Length",
    "Sepal.Width",
    "Species",
    "Petal.Width"
  )
)


#Reorder Column by Position
v<- c(
  5,
  4,
  1,
  2,
  3
)

data.table::setcolorder(
  diris,
  v
)


#==============================================================================
# Computing on Data and Creating Variables
#==============================================================================

#Reset the iris data tab;e
diris<-data.table::as.data.table(
  iris
)

data.table::setkey(
  diris,
  Species
)
 diris

 
#Create a new variable with :=
 
diris[
  ,
  V0:=0
]
diris[,V0:=0]
#:= Means - Modify this column by reference
 

#Create a new variable with := NULL
diris[,Sepal.Length:=NULL]


#Create Multiple Variables Simultaneously
diris[
  ,
  c("X1", "X2") := .(
    1L,
    2L
  )
]


diris[
  ,
  c("X3", "X4") := .(
    3,
    4
  )
]


#Create Variable from Existing Variables
diris[
  ,
  V :=Petal.Length*Petal.Width
]


#Delete Multiple VARIIABLES

diris[
  ,
  c("V", "V0"):=NULL
]

#Combine ROWS and COlumns - i and j

diris[
  "setosa",
  V:= Petal.Length*Petal.Width
]

#Different  calculation for another group

diris[
  "virginica",
  V:=sqrt(
    Petal.Length*Petal.Width
  )
]


#Calculations in J

#Ordinary R
mean(
  diris$Sepal.Width
  )

#Returns Mean too
diris[
  ,
  mean(
    Sepal.Width
  )
]

#Data table

diris[
  ,
  .(
    M = mean(Sepal.Width)
  )

]


#Introduce by

diris[
  ,
  .(
    M = mean(Sepal.Width)
  ),
  by=Species
]


#Multiple Calculations in a Group

diris[
  ,
  .(
    M1 = mean(Sepal.Width),
    M2 = mean(Petal.Width)
  ),
  by=Species
]

#Chaining Data Table Operations

diris[
  ,
  .(
    M1 = mean(Sepal.Width),
    M2 = mean(Petal.Width)
  ),
  by=Species
][
  ,
  .(
    r=cor(M1,M2)
  )
]

#Creating a variable using group-specific statistic
diris[
  ,
  MedPW:=Petal.Width>median(Petal.Width),
  by= Species
]


#Group by Multiple Variables
diris[
  ,
  .(
    M1 = mean(Sepal.Width),
    M2 = mean(Petal.Width)
  ),
  by= .(
    Species,
    MedPW

  )
]

#Block Chain another calculation
diris[
  ,
  .(
    M1 = mean(Sepal.Width),
    M2 = mean(Petal.Width)
  ),
  by= .(
    Species,
    MedPW
    
  )
][
  ,
  .(
    r=cor(M1,M2)
  ),
  by=MedPW
  
]


#===============================================================================
#Merging and Reshaping Data
#===============================================================================
diris<-data.table::as.data.table(iris)

#Creating dataset for merge examples
diris<-diris[
  ,
  .(
    Sepal.Width=Sepal.Width[1:3]
  ),
  keyby = Species
]



#One row per species
diris2<-diris[
  ,
  .SD[1],
  by=Species
]


#Dataset with 2 rows per species
dalt1<-data.table::data.table(
  Species=c(
    "setosa", "setosa",
    "versicolor", "versicolor",
    "virginica", "virginica",
    "other", "other"
  ),
  Type=c(
    "wide", "wide",
    "wide", "wide",
    "narrow", "narrow",
    "moderate", "moderate"
  ),
  MedPW=c(
    TRUE, FALSE,
    TRUE, FALSE,
    TRUE, FALSE,
    TRUE, FALSE
  )
)


data.table::setkey(
  dalt1,
  Species
)


#Keep two unique rows for one-one examples
#For each Species - Take the first Row
dalt2<-dalt1[
  ,
  .SD[1],
  by=Species
]
dalt2<-unique(dalt2)[1:2]

unique(dalt1)
#Insp3ct
diris
diris2
dalt1
dalt2

#One to One Merge
#Default merge only keeps keys appearing in both datasets - Common is Setosa so onely one row kept
merge(
  diris2,
  dalt2
)

#Keep Everything from X
merge(
  diris2,
  dalt2,
  all.x=TRUE
)


#Keep Everything from y
merge(
  diris2,
  dalt2,
  all.y=TRUE
)


#Keep Everything from both 
merge(
  diris2,
  dalt2,
  all=TRUE
)


#==============================================================================
#Default = inner join
#all.x = left join
#all.y = right join
#all = Full join
#==============================================================================

#One to Many Merge
#Inspect
diris
diris2
dalt1
dalt2

merge(
  diris,
  dalt2
)


#Many to Many Merge
merge(
  diris,
  dalt1,
  allow.cartesian = TRUE
)


#Why Multiple Key matter
#Set Multiple Keys before Merginmg , eg
#data.table::setkey( PC,USUBJID,PARAMCD, AVISIT,ATPT)



#=================================================================================
#Reshaping Data
###=====================================

#Reset the diris dataset
diris<-data.table::as.data.table(iris)

#Create a Unique Row ID
diris[
  ,
  ID:=1:.N
]

#Set ID as the Key
data.table::setkey(
  diris,
  ID
)

#Long vs wide - Diris is Wide - There are seperate columns for different measurements#
## In long, the repeated measuremens are stacked into fewer columns, with another column identifyinmg what the measurements are


#Wide to long with Melt()
diris.long<-data.table::melt(
  diris,
  measure.vars = list(
    c(
      "Sepal.Length",
      "Sepal.Width"
    ),
    c(
      "Petal.Length",
      "Petal.Width"
    )
  ),
  variable.name = "Type",
  value.name = c(
    "Sepal",
    "Petal"
  ),
  id.vars = c(
    "ID",
    "Species"
  )
)
diris.long

#To Make Type Meaningful

diris.long[
  ,
  Type:= factor(
    Type,
    levels=1:2,
    labels = c(
      "Length",
      "Width"
    )
  )
]


#Simpler Melt
diris.long2<-data.table::melt(
  diris,
  id.vars = c(
    "ID",
    "Species"
  )
)



#Long to Wide using dcast()
diris.wide0<-data.table::dcast(
  diris.long2,
  Species~variable
)
#


#Use the Unique ID
# ID+Species Identifies each Flower
diris.wide2<-data.table::dcast(
  diris.long2,
  ID+Species~variable
)


#Verify the Round trip
all.equal(
  diris.wide2,
  diris
)

#Different Orders so not comparable
names(diris.wide2)
names(diris)

#Making Comparision fair
diris.wide2<-diris.wide2[
  ,
  names(diris),
  with=FALSE
]

#Set Key so they have the same Keys before cpmparision below
data.table::setkey(
  diris,
  ID, Species
  )

#Verify the Round trip
all.equal(
  diris.wide2,
  diris
)


#Dcast equivalent for diris.long example

diris.wide<-data.table::dcast(
  diris.long,
  ID+Species~Type,
  value.var = c(
    "Sepal",
    "Petal"
  ),
  sep = "."
)




#Create Chapter 8 Directory 
chapter_dir<-file.path(
  "chapters",
  "chapter-08-data-munging"
)

if (!dir.exists(chapter_dir)){
  dir.create(
    chapter_dir,
    recursive = TRUE
  )
}


chapter_file<-file.path(
  chapter_dir, "Practice.R"
  )


if (!file.exists(chapter_file)){
  file.create(
    chapter_file
  )
}

file.edit(chapter_file)
