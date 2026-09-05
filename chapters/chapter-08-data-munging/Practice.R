#Chapter 8 - Data Munging with Data.Table  
#..........................................
# =================================================================
# CHAPTER 8
# data munging with data.table 
#=====================================================================


#Control printing and display options

#library(data.table)
#options(  stringsAsFactors=FALSE, datatable.print.nrows = 20, datatable.print.topn = 3, digits=2, width = 70)
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


