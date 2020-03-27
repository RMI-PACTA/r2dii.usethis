
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://i.imgur.com/3jITMq8.png" align="right" height=40 /> r2dii.usethis

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/r2dii.usethis)](https://cran.r-project.org/package=r2dii.usethis)
[![Travis build
status](https://travis-ci.org/2DegreesInvesting/r2dii.usethis.svg?branch=master)](https://travis-ci.org/2DegreesInvesting/r2dii.usethis)
[![R build
status](https://github.com/2DegreesInvesting/r2dii.usethis/workflows/R-CMD-check/badge.svg)](https://github.com/2DegreesInvesting/r2dii.usethis/actions)
[![Codecov test
coverage](https://codecov.io/gh/2degreesinvesting/r2dii.usethis/branch/master/graph/badge.svg)](https://codecov.io/gh/2degreesinvesting/r2dii.usethis?branch=master)
<!-- badges: end -->

The goal of r2dii.usethis is to automate the setup of r2dii packages and
projects. It aims to be an extension of the
[usethis](https://usethis.r-lib.org/) package, customize for [2 Degrees
Investing Initiative](https://2degrees-investing.org/).

## Installation

``` r
# install.packages("devtools")
devtools::install_github("2DegreesInvesting/r2dii.usethis")
```

## Example

```` r
r2dii.usethis::use_r2dii_data("new_data")
#> Add `new_data`
#> 
#> * [ ] Add "data-raw/new_data.csv" 
#> * [ ] Add "data-raw/data_dictionary/new_data.csv" 
#> * [ ] In "data-raw/new_data.R", add something like: 
#>   ```
#>   # Source: @<contributor> <URL to issue or pull request>
#>   new_data <- readr::read_csv(here::here("data-raw", "new_data.csv"))
#>   use_data(new_data, overwrite = TRUE)
#>   ```
#> * [ ] `usethis::use_r("new_data")`. Document `new_data` 
#> * [ ] `usethis::use_test("new_data")`. Add regression tests of `new_data` 
#> * [ ] `source("data-raw/data_dictionary.R"); devtools::load_all()` 
#> * [ ] `usethis::use_test("data_dictionary")`. Test `data_dictionary` includes `new_data`
````

``` r
usethis::use_template("README.Rmd", package = "r2dii.usethis")
```

## Information

  - [Getting
    help](https://2degreesinvesting.github.io/.github/SUPPORT.html).
  - [Contributing](https://2degreesinvesting.github.io/.github/CONTRIBUTING.html).
  - [Contributor Code of
    Conduct](https://2degreesinvesting.github.io/.github/CODE_OF_CONDUCT.html).
