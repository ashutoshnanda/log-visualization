library(shiny)

shinyUI(
    fluidPage(

        # Application title
        titlePanel("Log Visualization"),

        # Sidebar with a slider input for number of bins
        sidebarLayout(
            sidebarPanel(
                selectInput("select", label = h3("Log Type"), 
                        listChoices, selected = 0)
            ),

            mainPanel(
                h3("Visualization Results"),
                h4("Basic Information"),
                uiOutput("numEvents"),
                uiOutput("beginDate"),
                uiOutput("endDate"),
                h4("Accumulator Plot"),
                plotOutput("accumulator"),
                h4("Terms"),
                uiOutput("terms"),
                h4("Actual Logs"),
                tableOutput("logs")
            )
        )
    )
)