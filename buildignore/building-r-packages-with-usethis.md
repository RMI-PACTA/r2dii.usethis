gh doc with common settings
================

## Building R packages with usethis

All of my projects live under the same parent directory `git/`.

  - I open any RStuido project under `path/to/git/`.
  - This creates the package pkgname at `path/to/git/pkgname/`.

<!-- end list -->

``` r
usethis::create_package("../pkgname")
#> New project 'pkgname' is nested inside an existing project '../', which is rarely a good idea.
#> Error: User input required, but session is not interactive.
#> Query: Do you want to create anyway?
```

A new RStudio
