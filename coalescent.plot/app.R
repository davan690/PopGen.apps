library(shiny)
library(learnPopGen)

ui<-fluidPage(
  h3("Coalescent genealogy simulator",align="center"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId="n",
        label="number of individuals",
        value=20,min=0,max=100),
      sliderInput(inputId="ngen",
        label="number of generations",
        value=20,min=0,max=200),
      radioButtons(inputId="col.order",
        label="color ordering",
        choices=c("sequential","alternating"),
        selected="alternating"),
      checkboxInput(inputId="react",
        label=
        "reactive (plot changes instantly with new parameter values)",
        value=TRUE),
      textInput(inputId="seed",
        label="set seed (optional)",value=""),
      actionButton("newplot","new plot"),
      h4("Instructions:\n"),
      p("Choose number of individuals & population size 
        to simulate coalescence.\nSet the seed & gradually 
        increase the number of generations to watch fixation 
        occur.\n\n"),
      h4("Details:\n"),
      p("Web application for coalescent.plot of
        the learnPopGen R package (Revell, 2019).")
    ),
    mainPanel(
      plotOutput("plot",width="600px",height="800px")
    )
  )
)

server <- function(input, output) {
  output$plot<-renderPlot({
    if(!input$react){
      input$newplot
      isolate(
        if(input$seed!=""){
          set.seed(as.numeric(input$seed))
        }
      )
      input$newplot
      isolate(
        if(input$n>0&&input$ngen>0){
          coalescent.plot(input$n,input$ngen,sleep=0,
            col.order=input$col.order,
            mar=c(1.1,4.1,0,1.1))
        }
      )
    } else {
      input$newplot
      if(input$seed!="")
        set.seed(as.numeric(input$seed))
      if(input$n>0&&input$ngen>0)
        coalescent.plot(input$n,input$ngen,sleep=0,
          col.order=input$col.order,
          mar=c(1.1,4.1,0,1.1))
    }
  })
}

shinyApp(ui = ui, server = server)
