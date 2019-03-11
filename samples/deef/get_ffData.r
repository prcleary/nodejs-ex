# TODO check how deals with odd character encoding
# TODO get merge fields

get_ffData <- function(filepath,
                       verbose=FALSE) {
  
  # NB: only looks for legacy form fields currently
  # (others ignored)
  # NB: each form field must be in own table cell
  
  require(XML)
  require(xml2)  # Use only xpath (1.0) expressions
  
  if (!file.exists(filepath)) stop('File ', filepath,
  ' not found. Try changing working directory or giving full path.')
  
  if (verbose) message('Reading file: ', filepath)
  
  unzipped <- unzip(filepath, 'word/document.xml')
  doc_xml <- read_xml(unzipped)
  
  ffData_nodeset <- xml_find_all(doc_xml, './/w:ffData')
  num_ffData_nodes <- xml_length(ffData_nodeset)
  num_ffData <- length(num_ffData_nodes)
  
  if (length(num_ffData_nodes) > 1 && num_ffData_nodes[1] > 0) {
    
    ffData_results <- data.frame(
      name = rep(NA_character_, num_ffData),
      result = rep(NA_character_, num_ffData),
      stringsAsFactors = FALSE
    )
    
    for (i in 1:num_ffData) {
      
      if (verbose) message('Processing form field ', i)
      
      result <- NULL
      
      # Get names 
      # form field names in `name` node in `ffData` node
  
      ffData_node <- ffData_nodeset[i]
      name_node <- xml_find_first(ffData_node,
                                  './/w:name')
      name <- xml_attr(name_node, 'val')
      
      if (verbose) message('Name is ', name, ', ',
                           appendLF = FALSE)  
      ffData_results[i, 'name'] <- name
      
      # Look for nodes with results 
      
      # checkBox result is presence/absence of `checked` node 
      # downtree of `checkBox` node downtree of `ffData` node
      # val of checked is NA if checked, 0 if unchecked
      # checked is missing if default
      
      checkBox_node <- xml_find_first(ffData_node,
                                      './/w:checkBox')
      if (!is.na(xml_text(checkBox_node))) {
        
        checked <- xml_find_first(checkBox_node,
                                  './/w:checked')
        if (!is.na(xml_text(checked))) {  
          
          result <- ifelse(xml_attr(checked, 'val') %in% '0', 
                           '0', 
                           '1')
          
        } else {
          
          result <- '0'
          
        }
        
      }  
      
      # dropdown result is `result` node 
      # downtree of `ddList` node downtree of `ffData` node
      # NA if default selected
      
      ddList_node <- xml_find_first(ffData_node,
                                    './/w:ddList')
      
      if (!is.na(xml_text(ddList_node))) {  
        
        result_node <- xml_find_first(ddList_node, './/w:result')
        ddList_option_nodes <- xml_find_all(ddList_node,
                                       './/w:listEntry')
        ddList_options <- xml_attr(ddList_option_nodes,
                                   'val')
        result_index <- xml_attr(result_node, 'val')
        if (is.na(result_index)) {  
          
          result_index <- NULL
          result_index <- 1
          
        } else {
          
          # Deal with zero-based indexing
          result_index <- as.numeric(result_index) + 1
          
        }
        
        result <- ddList_options[result_index]
        
      }    
      
      textInput_node <- xml_find_first(ffData_node,
                                       './/w:textInput')
      
      if (!is.na(xml_text(textInput_node))) {
        
        # Select innermost containing paragraph
        # relative to `ffData_node`
        parent_para <- xml_find_first(textInput_node,
                                      "./ancestor::w:p")
        
        # Get `textInput` run
        textInput_run <- xml_find_first(textInput_node,
                                        "./ancestor::w:r")
         
        # Get remaining parent paragraph runs
        parent_para_runs <-
          xml_find_all(textInput_run, 
                       'following-sibling::w:r')
        
        # Get text from remaining following runs in parent paragraph
        parent_para_t <- xml_find_all(parent_para_runs,
                                      './/w:t')
        
        # Find all paragraphs that are following siblings
        following_para <-
          xml_find_all(parent_para,
                       "following-sibling::w:p")
        
        # Find all runs in those paragraphs
        following_para_runs <-
          xml_find_all(following_para,
                       "w:r")
        
        # Get text from runs in following paragraphs
        following_para_t <-
          xml_find_all(following_para_runs,
                       './/w:t')
        
        result <- paste0(c(xml_text(parent_para_t), 
                           xml_text(following_para_t)), 
                         collapse = '')
        
        result <-
          gsub("\\s+", " ", str_trim(result))
        
      }
      
      if (verbose) message('Result is ', result)
      
      if (exists('result')) {
        ffData_results[i, 'result'] <- result
        
      }
      
    }
    
    ffData_results <- rbind(ffData_results,
                            c('filename', basename(filepath)))
    n <- ffData_results$name
    transposed <- as.data.frame(t(ffData_results[,-1]))
    colnames(transposed) <- n
    
    data.frame(lapply(transposed, as.character),
               stringsAsFactors=FALSE)
    
  } else {
    
    message('No form fields found in ', filepath)
    
    data.frame(stringsAsFactors=FALSE)
    
  }
  
}

