### This is the R-script with the user interface
#load packages that we will use
library(shiny)

# This function registers a user interface with Shiny in ui.Rfile.
  #Functions for creating fluid page layouts. A fluid page layout consists of rows which in turn include columns. 
  #Rows exist for the purpose of making sure their elements appear on the same line (if the browser has adequate width). 
  #Columns exist for the purpose of defining how much horizontal space within a 12-unit wide grid it's 
  #elements should occupy. Fluid pages scale their components in realtime to fill all available browser width.
  fluidPage(
    titlePanel('My shiny app'),
    #Create a tabset that contains tabPanel elements. Tabsets are useful for dividing output into multiple 
    #independently viewable sections.
    tabsetPanel(
      tabPanel("An example with histograms",
               #Create a layout with a sidebar and main area.
               sidebarLayout(
                 sidebarPanel(
                   #Create a set of radio buttons used to select an item from a list
                   radioButtons(inputId='n',label= 'No. of observations',list(10,100,1000,10000)),
                   br(),
                   #Write instructions for user
                   p('Select the No. of observations for the histogram')
                 ),
                   mainPanel(
                     tabPanel('Histogram', plotOutput('histogram'))
                   )))
      ,
      tabPanel("An example with interactive histograms",
               sidebarLayout(
                 sidebarPanel(
                   numericInput(inputId='n2',label= 'Number of observations',value = 1000,
                                min = 10,max = 100000000,step = 15),
                   br(),
                   p('Select the number of observations for the histogram')
                 ),
                 mainPanel(
                   tabPanel('Histogram', plotlyOutput('histogram2'))
                 )))
      ,
      tabPanel("Life years lost for Saudi Arabia",
               sidebarPanel(
                 p('Select a period to show LYL for that specific period.'),
                 selectInput( 'Period.Ind','Period for LYL',c("2000-2005",
                                                              "2005-2010",
                                                              "2010-2015"), 
                              selected = "2000-2005"),
                 p('Select the sex.'),
                 selectInput( 'Sex.Ind','Sex',c("Female","Male"), selected = "Female")
               ),
               mainPanel(
                 tabsetPanel(
                   tabPanel('Plot',
                            plotlyOutput('LYL.plot',width = '100%')
                   ),
                   tabPanel('Table',
                            dataTableOutput('LYL.table'))
                 )))
    )
  )


  
