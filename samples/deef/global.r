library(data.table)
library(DT)
library(shiny)
library(stringr)
library(XML)
library(xml2)

source('fixUploadedFilesNames.r')
source('get_ffData.r')

# Hide `structure` error (bug in DT)
# https://github.com/rstudio/shiny/issues/1682
options(warn=-1)
  
