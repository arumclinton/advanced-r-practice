#Writing R Package
#A package takes reusable functions and puts them into a standardised structure
##Four Main development tools
#devtools - Package-development workflow
#roxygen2 - Function/package documentation
#testthat - Automated testing
#covr - Test coverage
#usethis - Automates a lot of project set up

#Not installing everything Blindly - Use below
renv::status()
install.packages(
  c(
    "devtools", "roxygen2","testthat","usethis","covr"
    )
  )
 renv::status()

 #Adding Snapshot records the project package dependancies and their versins in renv.lock
 renv::snapshot()

 #Do we need Rtools?
 pkgbuild::has_build_tools(debug = TRUE)

#Creating First Package - As A repository - 
 usethis::create_package("C:/Users/arumc/OneDrive/Документы/Git Practice/rpracticeutils")
renv::install("usethis")
packageVersion("usethis")
renv::snapshot()
getwd()

getwd()
renv::install("here")
here::dr_here()
dir.exists("C:/Users/arumc/OneDrive/Документы/Git Practice/rpracticeutils")
dir.exists("C:/Users/arumc/OneDrive/Документы/Git Practice")
list.files(
  "C:/Users/arumc/OneDrive/Документы/Git Practice", all.files = TRUE
)


setwd("C:/Users/arumc/OneDrive/Документы/Git Practice")
getwd()
usethis::create_package("rpracticeutile")
