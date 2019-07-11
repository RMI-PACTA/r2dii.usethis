## Similar to travis (https://www.jimhester.com/2017/10/13/docker/)
FROM rocker/r-apt:trusty

## RUN apt-get update
## RUN apt-get install -y libcurl4-openssl-dev libssl-dev libssh2-1-dev libxml2-dev

ENV CRAN https://cran.rstudio.com/
RUN R -e "install.packages('devtools')"

## In the container ---------------------------------------------------------

## docker run --rm -v /c/Users/Mauro/git/FIXME-PACKAGE-NAME:/opt/FIXME-PACKAGE-NAME -it FIXME-IMAGE-TAG /bin/bash
## cd opt/git/FIXME-PACKAGE-NAME

## remotes::install_local('.', dependencies = TRUE)

## devtools::load_all()
## devtools::test()
## devtools::check()
