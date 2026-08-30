  getwd()
#Chapter 7 - Data Management  
#..........................................
# =================================================================
# CHAPTER 7
# INTRODUCTION TO DATA MANAGEMENT USING data.table
#=====================================================================
library(data.table)
packageVersion("data.table")  

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

anyDuplicated(
  diris$Sepal.Length
  )

table(
  duplicated(diris)
)

data.table::key(diris)
unique(diris)
