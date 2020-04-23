## install ReinforcementLearning package
install.packages("ReinforcementLearning")

## install RBM package
install.packages("devtools") # install devtools first if it is not already installed
library(devtools)
install_github("TimoMatzen/RBM") # install from github since there is no repo on CRAN

## install keras
devtools::install_github("rstudio/keras")

library(keras)
install_keras()

# for the gpu version :
install_keras(gpu=TRUE)

## install H2O
# remove any old versions of h2o 
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# install RCurl and jsonlite if not already installed
pkgs <- c("RCurl","jsonlite")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# install H2O from the AWS server
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/latest_stable_R")))

## install MXNet

# install the package from AWS 
cran <- getOption("repos")
cran["dmlc"] <- "https://apache-mxnet.s3-accelerate.dualstack.amazonaws.com/R/CRAN/"
options(repos = cran)
install.packages("mxnet")

# install openCV and openBLAS if they are not already installed
# using the cammand line from Terminal on a Mac run the following lines:

# brew install opencv
# brew install openblas

# create a symbolic link to ensure the latest version of openBLAS is being used:

#ln -sf /usr/local/opt/openblas/lib/libopenblas.dylib /usr/local/opt/openblas/lib/libopenblasp-r0.3.1.dylib