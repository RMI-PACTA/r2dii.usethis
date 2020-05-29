#' Define columns of a dataset
#' 
#' This function helps you write the `@format` section of a dataset's help file.
#' Write the help file with that packages roxygen2 and call this function with:
#' ```
#' `r r2dii.usethis::use_column_definitions()`
#' ```
#' 
#' @param dataset A character string giving the name of a dataset.
#' @param dictionary A dataframe structured as in the example below.
#' 
#' @return A character vector of subclass "glue".
#'
#' @export
#' 
#' @examples
#' dictionary <- data.frame(
#'   stringsAsFactors = FALSE,
#'   dataset = paste0("dataset_", c(1, 1, 2, 2)),
#'   column = letters[1:4],
#'   typeof = c("character", "integer", "double", "factor"),
#'   definition = paste0("Definition of ", letters[1:4])
#' )
#' 
#' dictionary 
#' 
#' 
#' use_column_definitions(dictionary, dataset = "dataset_1")
#' 
#' use_column_definitions(dictionary, dataset = "dataset_2")
use_column_definitions <- function(dictionary, dataset) {
  stopifnot(is.character(dataset), is.data.frame(dictionary))
  
  d <- dictionary
  d <- d[d$dataset == dataset, , drop = FALSE]
  
  out <- sprintf("* `%s` (%s): %s.", d$column, d$typeof, d$definition)
  # HACK: We don't use glue but it's class helps get the correct format
  class(out) <- c("glue", class(out))
  
  out
}

