# Chapter 2 practice

getwd()
list.files()
?'+'
help('+')


#System and Files
#Time
Sys.Date()
Sys.time()
Sys.Date()





#Overview This Chapter Covers help files, working with the file system, and reading and writing files in R.

## System Files
Sys.Date()
Sys.time()
Sys.Date()


## Working Directory
getwd()
list.files()

## Checking Files
file.exists('README.Rmd')
file.exists('no_file.txt')


## File Information
file.info('README.Rmd')


## Creating and removing files
file.create('test_readme.txt')
file.remove('test_readme.txt')


## Copying and Renaming Files

file.create('source_file.txt')
file.copy('source_file.txt', 'copy_file.txt', overwrite = TRUE)
file.rename('copy_file.txt','renamed_file.txt')
file.remove('source_file.txt', 'renamed_file.txt')



## Creating Folders

dir.create('test_folder')
list.files()
dir.exists('test_folder')
unlink("test_folder", recursive = TRUE, force=TRUE)

##Input Output
#Create folders for output and input

dir.create('C:\\Users\\arumc\\OneDrive\\Документы\\Git Practice\\advanced-r-practice\\datasets\\pharmaverse')
dir.create('C:\\Users\\arumc\\OneDrive\\Документы\\Git Practice\\advanced-r-practice\\datasets\\practice')
dir.create('C:\\Users\\arumc\\OneDrive\\Документы\\Git Practice\\advanced-r-practice\\datasets\\sashelp')
dir.create('C:\\Users\\arumc\\OneDrive\\Документы\\Git Practice\\advanced-r-practice\\datasets\\cdisc')
dir.create('C:\\Users\\arumc\\OneDrive\\Документы\\Git Practice\\advanced-r-practice\\datasets\\csv')

dir.create('C:\\Users\\arumc\\OneDrive\\Документы\\Git Practice\\advanced-r-practice\\datasets\\excel')
dir.create('C:\\Users\\arumc\\OneDrive\\Документы\\Git Practice\\advanced-r-practice\\datasets\\sas')
dir.create('C:\\Users\\arumc\\OneDrive\\Документы\\Git Practice\\advanced-r-practice\\datasets\\spss')
dir.create('C:\\Users\\arumc\\OneDrive\\Документы\\Git Practice\\advanced-r-practice\\datasets\\stata')


#Packages for Data
install.packages(c('pharmaversesdtm', 'haven'))
library('pharmaversesdtm')
install.packages('remotes')
pkgbuild::has_rtools(debug = TRUE)

remotes::install_github('pharmaverse/admiraldev')
remotes::install_github('pharmaverse/admiral')
library(admiraldev)
library(admiral)
library(pharmaversesdtm)


#Read in Datasets
data('dm')
data('ex')
data('pc')
data('pp')

#Write daatset to folders
library(haven)
packageVersion("haven")
write_sas(admiral::admiral_adsl,"datasets/admiral/adsl.xpt")

#PP
write_sas(pharmaversesdtm::pp,"datasets/cdisc/pp.xpt")
write_sas(pharmaversesdtm::pp,"datasets/cdisc/pp.sas7bdat")

#PC
write_sas(pharmaversesdtm::pc,"datasets/cdisc/pc.xpt")
write_sas(pharmaversesdtm::pc,"datasets/cdisc/pc.sas7bdat")

#DM
write_sas(pharmaversesdtm::dm,"datasets/cdisc/dm.xpt")
write_sas(pharmaversesdtm::dm,"datasets/cdisc/dm.sas7bdat")

#EX
write_sas(pharmaversesdtm::ex,"datasets/cdisc/ex.sas7bdat")
write_sas(pharmaversesdtm::ex,"datasets/cdisc/ex.xpt")

