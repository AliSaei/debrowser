library(debrowser)
library(reshape2)

options(warn =-1)

header <- dashboardHeader(
  title = "DEBrowser Density Plots"
)
sidebar <- dashboardSidebar(  sidebarMenu(id="DataAssessment",
      menuItem("Density", tabName = "Density"),
      textInput("maxCutoff", "Max Cutoff", value = "10" ),
      plotSizeMarginsUI("density", h=400, t=0, b=0,r=0,l=0),
      plotSizeMarginsUI("afterFiltering", h=400, t=0, b=0,r=0,l=0)
))

body <- dashboardBody(
  tabItems(
    tabItem(tabName="Density", 
        fluidRow(
            column(12,
                getDensityPlotUI("density"))),
        fluidRow(
            column(12,
                getDensityPlotUI("afterFiltering"))
        )
    )
  ))

ui <- dashboardPage(header, sidebar, body, skin = "blue")

server <- function(input, output, session) {
    load(system.file("extdata", "demo", "demodata.Rda",
                   package = "debrowser"))
    filtd <- reactive({
        # Filter out the rows that has maximum 100 reads in a sample
        subset(demodata, apply(demodata, 1, max, na.rm = TRUE)  >=  
                   as.numeric(input$maxCutoff))
    })
    observe({
        if(!is.null(filtd())){
            callModule(debrowserdensityplot, "density", demodata)
            callModule(debrowserdensityplot, "afterFiltering", filtd())
        }
    })
}

shinyApp(ui, server)
