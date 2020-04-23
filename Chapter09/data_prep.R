library(jpeg)
library(purrr)
library(abind)
library(OpenImageR)

setwd('data/faces')
filename_vector = list.files(pattern="*.jpg")
image_list <- purrr::map(filename_vector, jpeg::readJPEG)

image_list <- purrr::map(image_list, ~OpenImageR::resizeImage(., width=50, height=50, method = "nearest"))

image_array <- abind::abind( image_list, along = 0)
dim(image_array)

rm(image_list,filename_vector)

setwd('../..')