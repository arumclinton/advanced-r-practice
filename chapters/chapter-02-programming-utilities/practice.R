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

git remote -v
