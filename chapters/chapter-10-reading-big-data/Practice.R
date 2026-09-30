#==============================================================================
#
# CHAPTER 10 - Reading Big Data
# Postgres Password = advancedryy
#===============================================================================
# 10.1 - Installed PostgreSQL server and check that Client is available -= Version 16.15 installed
#system("pg_isready -h localhost -p 5432", intern = TRUE)

#  10.2 Interfacing R and PostgreSQL
#Install the modern R packages for the Chapter
#renv::install(c("DBI", "RPostgres", "keyring"))
#Load Libraries
library(DBI)
library(RPostgres)
library(keyring)

#Storing Password securely
keyring::key_set(
  service = "advanced-r-postgres",
  username = "postgres"
)

#Create the connection
conSuper<-DBI::dbConnect(
  RPostgres::Postgres(),
  dbname="postgres",
  host="localhost",
  port=5432,
  user="postgres",
  password=keyring::key_get(
    service = "advanced-r-postgres",
    username = "postgres"
  )
)


#Verify Connection
DBI::dbGetInfo(conSuper)


#10.3 - Database Philosophy =  Important for Size, Confidentiality/Access Control, and reliaility


#10.4 - Adding Data to PostgreSQL
# Book using aces_daily simulated dataset from JWileymisc
#renv::install("JWileymisc")
requireNamespace(
  "JWileymisc",
  quietly = TRUE
)

#Load Data
data(
  "aces_daily",
  package="JWileymisc"
)

#Change to tibble format
library(tidyverse)
aces_daily<-tibble::as_tibble(aces_daily)

#Split into 4 Relational Databases - ADDRESS, DEMOGRAPHICS, THRICEDAILYMETRICS, DAILYMETRICS
ADDRESS<-aces_daily %>% 
  dplyr::select(UserID) %>% 
  dplyr::distinct()

#Add simulated postcode to address
set.seed(42020)
ADDRESS<-ADDRESS %>% 
  dplyr::mutate(
    PostalCode=round(
      rnorm(
        dplyr::n(),
        mean = 4000,
        sd=300
      ),
      0
    )
  )

#Convert to lowercase
names(ADDRESS)<-tolower(
  names(ADDRESS)
)



DEMOGRAPHICS<-aces_daily %>% 
  dplyr::select(
    UserID,
    Age,
    BornAUS,
    SES_1,
    EDU
  ) %>% 
  dplyr::distinct()


#Surrogate ID for Demographics
DEMOGRAPHICS<-DEMOGRAPHICS%>% 
  dplyr::mutate( 
    SurrogateID=dplyr::row_number()
    )%>%
  dplyr::select(
    UserID,
    SurrogateID,
    Age,
    BornAUS,
    SES_1,
    EDU
  )

names(DEMOGRAPHICS)<-tolower(
  names(DEMOGRAPHICS)
)


#Two Repeated measurements Rables from aces_daily
#THRICEDAILYMETRICS

THRICEDAILYMETRICS<-aces_daily %>% 
  dplyr::select(
    UserID,
    SurveyInteger,
    SurveyStartTimec11,
    STRESS,
    PosAff,
    NegAff
  )
names(THRICEDAILYMETRICS)<-tolower(
  names(THRICEDAILYMETRICS)
)

#SDailymetrics
DAILYMETRICS<-aces_daily %>% 
  dplyr::select(
    UserID,
    SurveyDay,
    SOLs,
    WASONs,
    SUPPORT,
    COPEPrb,
    COPEPrc,
    COPEExp,
    COPEDis
  )
names(DAILYMETRICS)<-tolower(
  names(DAILYMETRICS)
)


dim(ADDRESS)#191/2
dim(DEMOGRAPHICS)#332/6
dim(THRICEDAILYMETRICS)#6599/6
dim(DAILYMETRICS)#6599/9

#Remove aces_daily from R environment - We have everything needed
rm(aces_daily)


#Writing the tables to PostgreSQL
DBI::dbWriteTable(
  conn=conSuper,
  name = "address",
  value = ADDRESS
)


DBI::dbWriteTable(
  conn=conSuper,
  name = "demographics",
  value = DEMOGRAPHICS
)

DBI::dbWriteTable(
  conn=conSuper,
  name = "thricedailymetrics",
  value = THRICEDAILYMETRICS
)


DBI::dbWriteTable(
  conn=conSuper,
  name = "dailymetrics",
  value = DAILYMETRICS
)


#VeriFy the Codes Created
DBI::dbListTables(conSuper)

#Verify Table contentd
DBI::dbGetQuery(
  conSuper,
  "SELECT * FROM address LIMIT 5"
)

DBI::dbGetQuery(
  conSuper,
  "SELECT COUNT(*) As n FROM address"
)

#Directly Checking that teh table exists
DBI::dbExistsTable(
  conSuper,
  "address"
)


## 10.5 - Creating users with Specific Privileges
# Most useful commands 
#CREATE USER
#GRAND
#REVOKE
#DROP USER


## 10.6 Password Security
# WWe already set password above so we need to get
keyring::key_get(
  service = "advanced-r-postgres",
  username = "postgres"
)


##10.7 SQL from R
#Inspec the database first
DBI::dbListTables(conSuper)

#Columns in a table
DBI::dbListFields(
  conSuper,
  "thricedailymetrics"
  )

#Bring the Entire database into R (Convenient for smaller tables)
query<-DBI::dbReadTable(
  conSuper,
  "thricedailymetrics"
)


#dbGetQuery - The most important one - Sends SQL directly to PostgreSQL

query<-DBI::dbGetQuery(
  conSuper,
  "
  SELECT * 
  FROM address
  "
)


#Select Only one Column
query<-DBI::dbGetQuery(
  conSuper,
  "
  SELECT postalcode 
  FROM address
  "
)

#Add filter - PostgreSQL does the filtering befiore sending to R
#You can request only what your analysis needs
query<-DBI::dbGetQuery(
  conSuper,
  "
  SELECT postalcode 
  FROM address
  where userid=1
  "
)


#10.7




