fixUploadedFilesNames <- function(x) {
  
  # rename uploaded files to real filenames
  # from http://tinyurl.com/nxcqluf
  
  if (is.null(x)) {
    return()
  }
  
  oldNames = x$datapath
  newNames = file.path(dirname(x$datapath),
                       x$name)
  file.rename(from = oldNames, to = newNames)
  x$datapath <- newNames
  x
}