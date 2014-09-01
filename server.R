library(shiny)
library(ggplot2)

toUI <- function(x) {
    list(HTML(paste("<div class = \"shiny-html-output\">", x, "</div>")))
}

shinyServer(
    function(input, output) {
        
        log.data.individual <- reactive(log.data.split[[input[["select"]]]])
        
        log.data.individual.timestamps <- 
                    reactive(log.data.split.timestamps[[input[["select"]]]])
        
        log.data.individual.timestamps.limits <- 
                reactive(log.data.split.timestamps.limits[[input[["select"]]]])
        
        log.data.individual.timeseries <- reactive(as.POSIXct(
                    seq(len = 1000, 
                        log.data.individual.timestamps.limits()[1],
                        log.data.individual.timestamps.limits()[2]), 
                origin = "1970-01-01"))
        
        log.data.individual.accumulator <- reactive({
            accumulator <- rep(0, length(log.data.individual.timeseries()))
            lapply(log.data.individual.timestamps(),
                function(x) accumulator[x <= log.data.individual.timeseries()] 
                    <<- accumulator[x <= log.data.individual.timeseries()] + 1)
            accumulator <- accumulator / accumulator[length(accumulator)]
        })
        
        log.data.individual.hasMultiple <- reactive({
            nrow(log.data.split[[input[["select"]]]]) > 1
        })
        
        output[["numEvents"]] <- renderUI({
            toUI(
                if(log.data.individual.hasMultiple()) {
                    sprintf("Your log message type (%s) has %d logs.",
                            input[["select"]], nrow(log.data.individual()))
                } else{
                    sprintf("Your log message type (%s) has %d log.<br>%s%s",
                            input[["select"]], nrow(log.data.individual()),
                            "<font color = \"blue\">Because there is only 1 log", 
                            ", no plot will be produced.</font>")
                }
            )
        })
        
        output[["beginDate"]] <- renderUI({
            toUI(sprintf("<strong>First Log Time:</strong> %s", 
                log.data.individual.timestamps.limits()[1]))
        })
        
        output[["endDate"]] <- renderUI({
            toUI(sprintf("<strong>Last Log Time:</strong> %s", 
                log.data.individual.timestamps.limits()[2]))
        })
                
        output[["accumulator"]] <- renderPlot({
            if(log.data.individual.hasMultiple()) {
                plot(
                    log.data.individual.timeseries(), 
                    log.data.individual.accumulator(), type = "s",  
                    main = sprintf("Accumulator Plot for Log Type %s", 
                                input[["select"]]), ylim = c(0, 1),
                    xlab = "Time", ylab = "Percentage of Events", col = "blue")
                grid()
            }
        })
        
        output[["terms"]] <- renderUI({
            toUI(gsub(" ", "<br>", 
                      types.data.split[[input[["select"]]]][["Words"]]))
        })
        
        output[["logs"]] <- renderTable({
            log.data.individual()["Raw.Log"]
        })
    }
)