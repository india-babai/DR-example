server <- function(input, output, session) {
  output$prob_bttn <- renderUI({
    if (input$delay != 1) {
      checkboxInput(inputId = "prob_bttn",
                                    strong("Adjust probability?"),
                                    value = F)
      
    }
  })
}