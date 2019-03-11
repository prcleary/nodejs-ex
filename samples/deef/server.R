shinyServer(function(input, output) {
  
  cat('Server starting\n')
  
  wordfiles <- reactive(fixUploadedFilesNames(input$wordfiles))
  
  observe({
    validate(
      need(!is.null(wordfiles()$datapath),
                    'No files uploaded'))
  })
  
  output$wordfiles <- renderDataTable({ 
    wordfiles()
    })
  
  formdata <- reactive({     
    
    if (input$verbose) cat('\n', paste(wordfiles()$datapath, '\n'))
    datalist <- lapply(as.list(wordfiles()$datapath),  
                       function(x) get_ffData(x, verbose=input$verbose))  
    output <- rbindlist(datalist, use.names=TRUE, fill=TRUE) 
    row.names(output) <- NULL
    output
  })
  
  output$formdata <- DT::renderDataTable({   
    formdata() 
    },  extensions = 'Buttons',  
    options = list(   
      dom = 'Bfrtip',   
      buttons = c('copy',  
                  'excel', 
                  'csv' 
                  )),
    server=FALSE)
  
})
