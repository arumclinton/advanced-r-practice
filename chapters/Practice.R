#==============================================================================#
# Chapter13 Notes
# Every Cloud has a Shiny lining - Shiny web Applications
#===============================================================================#

#Simplest Shiny app
library(shiny)

#Creates a webpage(Empty)
ui<-fluidPage()

#R calculations live here
server<-function(input, output){
}

#Start Application - Connects the UI and Server and Launches the Application
shinyApp(
  ui=ui,
  server = server
)



#Addeing Numeric Input to the Shiny 
#Creates a webpage(Numeric Input)
ui<-fluidPage(
  numericInput(
    inputId = "pie",
    label = "Percent of Pie Chart",
    value = 50,
    min = 0,
    max = 100
  ),
  plotOutput("piePlot")
)


#Connect the Numericinput to the Server
server<-function(input, output){
  output$piePlot<-renderPlot({
    y<-c(
      input$pie,
      100 - input$pie
    )
    
    barplot(
      y,
      ylim=c(0,100),
      names.arg=c(
        "Selected",
        "Complement"
      )
    )
    
  
  }
    
  )
}

shinyApp(
  ui=ui,
  server = server
)


#Add a text input
#Helps user Control Chat Title

ui<-fluidPage(
  numericInput(
    inputId = "pie",
    label = "Percent of Pie Chart",
    value = 50,
    min = 0,
    max = 100
  ),
  
  textInput(
    inputId = "pietext",
    label = "Text Input",
    value = "Default Title",
    placeholder = "Enter Your Title Here"
  ),
  plotOutput("piePlot")
)


#Connect the Numericinput to the Server
server<-function(input, output){
  output$piePlot<-renderPlot({
    y<-c(
      input$pie,
      100 - input$pie
    )
    
    barplot(
      y,
      ylim=c(0,100),
      names.arg=c(
        input$pietext,
        paste0("Complement of ",input$pietext )
      )
    )
    
    
  }
  
  )
}

shinyApp(
  ui=ui,
  server = server
)


#Adding Checkbox

#===============================================================================
#USER INTERFACE
#================================================================================
ui<-fluidPage(
  
  #Application Title
  titlePanel("User Controlled Chart"),
  
  #Layout
  sidebarLayout(
    
    #User inputs
    sidebarPanel(
      
      
      numericInput(
        inputId = "pie",
        label = "Percent of Pie Chart",
        value = 50,
        min = 0,
        max = 100
      ),
      
      textInput(
        inputId = "pietext",
        label = "Text Input",
        value = "Default Title",
        placeholder = "Enter Your Title Here"
      ),
      
      checkboxInput(
        inputId = "pieChoice",
        label = "I want a Pie Chart intstead",
        value = FALSE
      )
    ),
    
    #Output
    mainPanel(
      plotOutput("piePlot")
    )
  )
  
)
  
  
#===============================================================================
#SERVER
#===============================================================================

#Connect the Numericinput to the Server
server<-function(input, output){
  output$piePlot<-renderPlot({
    
    #Calculate the two Portions
    y<-c(
      input$pie,
      100 - input$pie
    )
    
    
    # Choose Bar Plot or Pie Chart
    if(input$pieChoice==FALSE){
      barplot(
        y,
        ylim=c(0,100),
        names.arg=c(
          input$pietext,
          paste0("Complement of ",
                 input$pietext 
          )
        )
      )
      
    } else {
      
      pie(
        y,
        labels=c(
          input$pietext,
          paste0("Complement of ",
                 input$pietext 
          )
        )
      )
    }
  })
}



#===============================================================================
# RUN THE APPLICATION
#===============================================================================
shinyApp(
  ui=ui,
  server = server
)


#===============================================================================
# 13.2    - SHINY IN MOTION
#===============================================================================
#Reactivity
#Slider Inputs = Check Example

#===============================================================================
#13.3 -  Uploading a User File into Shiny - fileinput
#===============================================================================

#Creting tiny hist data
hist_data<-data.frame(
  X1=c(1:10)
)

write.csv(
  hist_data,
  "hist_data.csv",
  row.names = FALSE
  )



library(shiny)
ui<-fluidPage(
  
  fileInput(
    "file",
    label = h3("Histogram Data File Input"),
    multiple = FALSE
  ),
  
  tableOutput("tabledf"),
  tableOutput("tabledf2"),
  plotOutput("histPlot1")
  
)


server<-function(input, output){

  output$tabledf<-renderTable({
    input$file
  })
  
  histData<-reactive({
    file1<-input$file
    
    read.csv(
      file1$datapath,
      header = TRUE,
      sep = ","
    )
  })
  
  output$tabledf2<-renderTable({
    histData()
  })
  
  output$histPlot1<-renderPlot({
    hist(
      as.numeric(histData()$X1)
    )
  })
}


shinyApp(
  ui=ui,
  server = server
)

