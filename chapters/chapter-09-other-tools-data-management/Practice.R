# ===================================================================
# CHAPTER 09
# OTHER TOOLS FOR DATA MANAGEMENT
#=====================================================================

#Packaged
library(dplyr)
library(tibble)

#Display Options
options(
  stringsAsFactors=FALSE,
  tibble.print_max=20,
  tibble.print_min=5,
  digits=2
)

#iris$Species<-as.character( iris$Species) - Not Neccessary Step so commenting out
class(iris$Species)
diris<-tibble::as_tibble(
  iris
)


#Sort Rows = Using arrange()
diris<-dplyr::arrange(
  diris,
  Sepal.Length
)

#Sorting using multiple variables

diris<-dplyr::arrange(
  diris,
  Sepal.Length,
  dplyr::desc(Sepal.Width)
)


#Find the First Duplicate
anyDuplicated(diris)
diris[77:81,]

#Specific vatriable
anyDuplicated(diris$Sepal.Length)
diris$Sepal.Length[1:4]

#Count Duplicated vs Non Duplicated Rows
table(duplicated(diris))
table(duplicated(diris$Sepal.Length))

#Keep only unique rows - distinct()
dplyr::distinct(diris)
dplyr::distinct(diris,Sepal.Length)
dplyr::distinct(diris,Sepal.Length, Sepal.Width)


#Selecting and Sub-setting#
dplyr::slice(
  diris,
  1:5
  )


#Exclude rows
dplyr::slice(
  diris,
  -(1:145)
)
diris %>% 
  dplyr::slice_tail(n=5)

#Select Row based on Values
dplyr::filter(
  diris,
  Species=="setosa"
)

#Ignre case
dplyr::filter(
  diris,
  toupper(Species)=="SETOSA"
)



dplyr::filter(
  diris,
  Species!="setoa"
)

#Can use several conditins with &, |, <, > 

# %in%  - One of several values
interest<-c(4.4,4.3)
dplyr::filter(
  diris,
  Sepal.Length %in% interest
)

#Not in
dplyr::filter(
  diris,
  !Sepal.Length %in% interest
)


#Selecting Columns y name
dplyr::select(
  diris,
  Sepal.Length,
  Sepal.Width
)
diris %>% dplyr::select(
    Sepal.Length,
  Sepal.Width)

#Selecting Columns position - Use with care - Positin changes
dplyr::select(
  diris,
  1,
  5,
  2
)

#Store Column names in R object
v<-c(
  "Sepal.Length",
  "Sepal.Width"
)

#All of means - every variable in V must exist
 dplyr::select(
   diris,
   dplyr::all_of(v)
 )
 
 #Any_of() means - Selct whichever variable from V exist: Dont fail because some of them are absent
 
 
 #Extract a column from a vector
 # diris$Sepal.Length and diris[["Sepal.Length]] - Both returns numeric vector rather than tibble
 #diris %>% select(Sepal.Length) - Returns Tibble
 
 #Exclude colimns
 dplyr::select(diris,
   -Sepal.Length,
 )
# Remove evrything, remove by position also posible
 
 #Remove from Vector
 dplyr::select(
   diris,
   -dplyr::all_of(v)
 )

 #Selction Helpers
 diris %>% 
   dplyr::select(
     dplyr::starts_with("S")
   )
 
 
 diris %>% 
   dplyr::select(
     dplyr::starts_with(
       "s",
       ignore.case = FALSE
       
       )
     
   )
 
 
 diris %>% 
   dplyr::select(
     dplyr::ends_with("Width")
   )
 
 diris %>% 
   dplyr::select(
     dplyr::contains("Petal")
   )

 diris %>% 
   dplyr::select(
     dplyr::matches("Length$")# Selects names ending with Lenth
   ) 

 
 #==============================================================================
 # Variable RENAMING AND ORDERING
 #==============================================================================
 #Inspect Column names
 names(diris)
 colnames(diris) 
 
 
 #Rename
 diris<-dplyr::rename(
   diris,
   SepalLength=Sepal.Length
 )
 names(diris)

 
 #Reorder Columns with Select
 diris<-diris %>% dplyr::select(
   
   SepalLength,
   Petal.Length,
   Sepal.Width,
   Petal.Width,
   Species 
 )
 names(diris)
#Can reorder using position
 
 #Relocae() -Move Species before SepalLength
 
 diris<-diris %>% dplyr::relocate(
   Species,
   .before = SepalLength
 )
 
 #==============================================================================
 # COMPUTING ON DATA and CREATING VARIABLES
 #==============================================================================
 
 
 #Reset diris dataset
 diris<-tibble::as_tibble(iris)
 
 #Create new variables - Use Mutate()
 diris<-diris %>% 
   dplyr::mutate(
     V0=0,
     X1=1L,
     X2=2L
   )
 
 #Rwmove them
 diris<-diris %>% 
   dplyr::select(
     -V0,
     -X1,
     -X2
   )
 
 #If_else - Conditiona;l derivation
 diris<-diris %>% 
   dplyr::mutate(
     V2=dplyr::if_else(
       Species=="setosa",
       Petal.Length*Petal.Width,
       NA_real_
     )
   )
 
 diris[140,]
 
 #If_else  - Modifying same variab;le
 diris<-diris %>% 
   dplyr::mutate(
     V2=dplyr::if_else(
       Species=="virginica",
      sqrt( Petal.Length*Petal.Width),
       V2      #If not Virginioca, retain the value as it is
     )
   )
 
 
 
 #Inspect
 dplyr::slice(diris, c(1,51,101))

 #Summarize() Summary stats - Collapses observarions, unlike mutate()
 dplyr::summarise(
   diris,
   M=mean(Sepal.Width),
   SD=sd(Sepal.Width)
 )
 
 
 #Use Pipe Operation and Seperate by using grpup_by()
 diris%>% dplyr::group_by(
   Species
   ) %>% 
   dplyr::summarise(
     m1=mean(Sepal.Width),
     m2=mean(Petal.Width)
   )
   
 
 #Add/Chain Another calculation
 
 diris%>% dplyr::group_by(
   Species
 ) %>% 
   dplyr::summarise(
     m1=mean(Sepal.Width),
     m2=mean(Petal.Width)
   ) %>% 
   dplyr::summarise(
     r=cor(m1, m2)
   )

 #Grouped Mutate
 diris<-diris %>% 
   dplyr::group_by(Species) %>%  # Calculate three medians = For each Specie
   dplyr::mutate(
     MedPW=Petal.Width>median(Petal.Length)
   )
 
 #Wecan Group by 2 Variab;les too. Also Chain more than 1 group_by
 diris %>% 
   dplyr::group_by(
     Species,
     MedPW
   ) %>% 
   dplyr::summarise(
     M1=mean(Sepal.Width),
     M2=mean(Petal.Width)
   ) %>% 
   dplyr::group_by(MedPW) %>% 
   dplyr::summarise(
     r=cor(M1,M2)
   )
#Ungroup
 
 diris<-diris %>% 
   ungroup()

 
 #============================================================================
 #Merging and Reshaping
 #
 #============================================================================
#Reset Diris dataset
 diris<-tibble::as_tibble(iris)
 
 
 #Select First three observations per each species
diris<-diris %>%  
  dplyr::group_by(Species) %>% 
  dplyr::select(
    Species,
    Sepal.Width
  ) %>% 
  dplyr::slice(1:3)

 
#One Row per species
diris2<-dplyr::slice(
  diris,
  c(1,4,7)
)


#Creatweing a dataset to use fpr merging
dalt1<-tibble::tibble(
  Species=c(
    "setosa",
    "setosa",
    "versicolor",
    "versicolor",
    "virginica",
    "virginica",
    "other",
    "other"
  ),
  Type=c(
    "wide",
    "wide",
    "wide",
    "wide",
    "narrow",
    "narrow",
    "moderate",
    "moderate"
  ),
  MedPW=c(
    TRUE,
    FALSE,
    TRUE,
    FALSE,
    TRUE,
    FALSE,
    TRUE,
    FALSE
  )
)


dalt2<-dplyr::slice(
  dalt1,
  c(1,3)
)

#Historical Merge - Base R
merge(
  diris2,
  dalt2
)

#Keep all rows from first dataset - Sinmilar to left join
merge(
  diris2,
  dalt2,
  all.x = TRUE
)


#Modern dplyr - Keep all rows from first dataset
dplyr::left_join(
  diris2,
  dalt2,
  by="Species"
)


#Modern dplyr - Keep all rows from second dataset
dplyr::right_join(
  diris2,
  dalt2,
  by="Species"
)

#Inner join - Keep only records that match both

dplyr::inner_join(
  diris2,
  dalt2,
  by="Species"
)


#Anti_join - Useful for validation - Brings records that exists in one dataset but has no matching key var in the other data

dplyr::anti_join(
  diris2,
  dalt2,
  by="Species"
)


#validation %>% dplyr::anti_join(production, by=keys) = Shows records in my validation dataset that cant be matched to prod



# Reshaping data ; Wide- Long - Wide

diris<-tibble::as_tibble(iris)
#n() Number of rows in the current group/data
diris<-dplyr::mutate(
  diris,
  ID=1:dplyr::n()
)


#Reshape from Wide to Long
diris.long<-tibble::as_tibble(
  reshape(
    as.data.frame(diris),
    varying=list(
      c(
        "Sepal.Length",
        "Sepal.Width"
      ),
      c(
        "Petal.Length",
        "Petal.Width"
      )
    ),
    timevar = "Type",
    v.names = c(
      "Sepal",
      "Petal"
    ),
    idvar = "ID",
    direction = "long"
  )
)

#Giving type Meaningful labels
diris.long<-dplyr::mutate(
  diris.long,
  Type=factor(
    Type,
    levels = 1:2,
    labels = c(
      "Length",
      "Width"
    )
  )
)

#Long back to wide
diris.wide2<-tibble::as_tibble(
  reshape(
    as.data.frame(diris.long),
    v.names = c(
      "Sepal",
      "Petal"
    ),
    timevar = "Type",
    idvar = "ID",
    ids = diris.long$ID,
    direction = "wide"
  )
)


#Modern Options
#Wide to Long with Pivot_longer

diris<-tibble::as_tibble(iris)

#Genearate ID
diris<-diris %>% 
  dplyr::mutate(
    ID=dplyr::row_number()
  )

#Reshape the 4 Measurements Column - Change from Wide to long
diris.long2<-diris %>% 
  tidyr::pivot_longer(
    cols=c(Sepal.Length,
           Sepal.Width,
           Petal.Length,
           Petal.Width
           ),
    names_to = c(".value", "Type"),
    names_pattern = "(Sepal|Petal)\\.(Length|Width)"
  )

#Make type a factor
diris.long2<-diris.long2 %>% 
  dplyr::mutate(
    Type=factor(
      Type,
      levels = c("Length", "Width")
    )
  )


#Long to Wide = pivot_wider
diris.wide3<-diris.long2%>% 
  tidyr::pivot_wider(
    id_cols=c(Species,
              ID
    ),
    names_from = Type,
    values_from = c(
      Sepal,
      Petal
    ) 
  )
