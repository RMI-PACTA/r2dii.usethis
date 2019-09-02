Building 2dii-like packages
================

The goal of this article is to show how to build r2dii-like packages.
All code should run in R (default), or a Unix-like terminal (commented
with `# bash`).

## Setup

  - Create the packagename package at `root/path/to/parent/`.

<!-- end list -->

    usethis::create_package("../r2dii.packagename")

  - Attach useful packages.

<!-- end list -->

    library(r2dii.usethis)
    library(usethis)
    library(devtools)

## Add minimal infrastructure

  - A new RStudio session will open; I attach usethis and setup git.

<!-- end list -->

    use_git()

  - For public packages add a common licence (see
    `?usethis::use_*_license()`).

<!-- end list -->

``` r
use_gpl3_license()
```

  - For private packages maybe add “Private package” in a `LICENSE` file
    at the root.

<!-- end list -->

``` bash
# bash
echo "Private package." > LICENSE
```

  - Allow opening the GitHub repo with `browse_github()`.

<!-- end list -->

    use_github_links()

  - On GitHub consider tweaking collaboration and branch settings.

<!-- end list -->

    browse_github()

  - Enable markdown syntax in R documentation.

<!-- end list -->

    use_roxygen_md()

  - Edit the DESCRIPTION file manually.
  - Tidy DESCRIPTION.

<!-- end list -->

    use_tidy_description()

  - Check.

<!-- end list -->

``` r
# Control + Shift + E
devtools::check()
```

  - Confirm that R CMD check runs with 0 errors, 0 warnings, and 0
    notes.
  - Create a GitHub repo and setup the remote `origin`.

<!-- end list -->

``` bash
# If using https
git remote add origin https://github.com/2DegreesInvesting/r2dii.git

# If using ssh
git remote add origin git@github.com:2DegreesInvesting/r2dii.git
```

(See also `?usethis::use_github()`)

## Extend infrastructure with templates

  - Install the package.

<!-- end list -->

    devtools::install()

  - Create README.Rmd from a template.

<!-- end list -->

``` r
use_template("README.Rmd", package = "r2dii.usethis")
use_cran_badge()
```

  - Edit README.Rmd manually.

  - Knit README.Rmd.

  - Check that R CMD check results in 0 errors, warnings, and messages.

<!-- end list -->

    devtools::check()

## What else?

The r2dii.usethis includes many more
[templates](https://github.com/2DegreesInvesting/r2dii.usethis/tree/master/inst/templates)

``` r
path_to_templates <- here::here("./inst/templates")
fs::path_file(fs::dir_ls(path_to_templates))
#>  [1] "CODE_OF_CONDUCT.md"     "CONTRIBUTING.md"       
#>  [3] "cran-comments.md"       "Dockerfile"            
#>  [5] "github_document.Rmd"    "ISSUE_TEMPLATE.md"     
#>  [7] "ONBOARDING.md"          "README.Rmd"            
#>  [9] "rmarkdown_template.Rmd" "SUPPORT.md"            
#> [11] "travis.yml"             "_pkgdown.yml"
```

For inspiration you may also see [this
post](https://fgeo.netlify.com/2018/03/28/2018-03-28-building-infrastructure-for-r-packages-with-usethis/)

The ultimate source is the R packages book:

  - [First edition](http://r-pkgs.had.co.nz/).
  - [Second edition](https://r-pkgs.org/) (work in progress; includes
    usethis).
