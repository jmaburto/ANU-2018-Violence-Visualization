#load the packages that we will use
library(shiny)
library(ggplot2)
library(plotly)
library(DT)
library(RColorBrewer)


  function(input,output){
  
    output$histogram <-  renderPlot({
      df  <- rnorm(input$n)
      df  <- data.frame(df)
      
      fig <- ggplot(data = df, aes(x = df))+
                geom_histogram(colour = 'black', fill = 'white', binwidth = 0.2)
      
      fig
    })
    
    output$histogram2 <- renderPlotly({
      
      df  <- rnorm(input$n2)
      df  <- data.frame(df) 
      
      fig <- ggplot(df, aes(x = df)) + 
        geom_histogram(colour = "black", fill = "white",binwidth = 0.2)
      
      ggplotly(fig,tooltip = c('count'))
      
    })
    
    load('ResultsLYL.RData')
    
    output$LYL.plot <- renderPlotly({
      
      Period1  <- input$Period.Ind
      Sex      <- input$Sex.Ind
      
      Data.fig     <- Results.LYL[Results.LYL$Period == Period1 & Results.LYL$Sex == Sex,]
      Data.fig$LYL <- round(Data.fig$LYL,3)
      
      p <- ggplot(Data.fig, aes(Age, label=LYL))+
        ggtitle(paste('Life years lost for the period', Period1))+
        geom_ribbon(aes(ymin = ymin,ymax =ymax, group=(Cause), fill=Cause), position = 'identity')+
        theme_light()+
        theme(text = element_text(size=10),
              axis.text.x = element_text(angle=45, hjust=1))+
        labs(x = "Age", y = "Probability of surviving and LYL",size=10)
      
      ggplotly(p,tooltip = c('Cause','Age','LYL'))
      
    })
    
    output$LYL.table = renderDataTable({
      
      Period1  <- input$Period.Ind
      Sex      <- input$Sex.Ind
      
      Data.table <- Table.LYL[Table.LYL$Period == Period1 & Table.LYL$Sex == Sex,]
      
      datatable(Data.table[,c(1,3)], options = list(paging=FALSE,ordering=T, dom = 't'),rownames = F,caption = 'Total life years lost by cause')
    })
    
  }

