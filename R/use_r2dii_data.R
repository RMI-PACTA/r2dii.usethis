#' A checklist to add new data to the package r2dii.data
#' 
#' @param name String of length 1 giving the name of the dataset, e.g.
#'   "ald_demo".
#'   
#' @return Printed output that you may copy and paste into a GitHub issue.
#'
#' @export
#' 
#' @examples
#' # Maybe copy and paste into a GitHub issue. 
#' # See `?usethis::browse_github_issues()`
#' use_r2dii_data()
#' 
#' use_r2dii_data("my_data")
use_r2dii_data <- function(name = NULL) {
  newdata <- name %||% "newdata"
  
  cat(glue("Add `{newdata}`\n\n\n"))
  
  todo(glue('Add "data-raw/{newdata}.csv"'))
  
  todo(glue('Add "data-raw/data_dictionary/{newdata}.csv"'))
  
  todo(glue('In "data-raw/{newdata}.R", add something like:'))
  cat(glue('
    ```
    # Source: @<contributor> <URL to issue or pull request>
    {newdata} <- readr::read_csv(here::here("data-raw", "{newdata}.csv"))
    use_data({newdata}, overwrite = TRUE)
    ```

  '))
  
  todo(glue('`usethis::use_r("{newdata}")`. Document `{newdata}`'))
  
  todo(glue(
    '`usethis::use_test("{newdata}")`. Add regression tests of `{newdata}`'
  ))
  
  todo(glue('`source("data-raw/data_dictionary.R"); devtools::load_all()`'))

  todo(glue(
    '`usethis::use_test("data_dictionary")`. Test `data_dictionary` includes \\
    `{newdata}`'
  ))
}

todo <- function(x) cat("* [ ]", x, "\n")

# From rlang::`%||%`
`%||%` <- function (x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}
