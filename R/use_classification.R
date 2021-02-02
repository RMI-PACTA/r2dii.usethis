#' Use a new sector classification in r2dii.data
#' 
#' These functions help you add a new sector classification bridge to the
#' package r2dii.data.
#'
#' @param prefix String. The prefix before _classification, e.g. "psic" in
#'   `psic_classification`.
#' @param dataset String. Name of the new classification dataset you want to
#'   add, e.g. `psic_classification`.
#' @param contributor String. Name of a contributor to thank in NEWS.md, e.g.
#'   "\@daisy-pacheco".
#' @param issue String. Number of related issue or PR, e.g. #199.
#' @param data A data frame.
#' @param string A string.
#'
#' @return Most functions are interactive, and called for their side effects.
#' The return value is usually `invisible(dataset)`.
#'
#' @examples
#' # See https://github.com/2DegreesInvesting/r2dii.data/issues/199
#' # Change directory into r2dii.data
#' \dontrun{
#' prefix <- "psic"
#' dataset <- name_dataset(prefix)
#' contributor <- "@daisy-pacheco"
#' issue <- "#199"
#' modify_news(dataset, contributor, issue)
#' modify_r_classification_bridge(dataset)
#' 
#' x <- readr::read_tsv("~/Downloads/NSCB_PACTA_bridge - PSIC_PACTA_bridge.tsv")
#' write_raw_data(x, dataset)
#' modify_data_raw_classification_bridge(dataset)
#' new_data_dictionary_entry(dataset)
#' modify_test_data_dictionary(dataset)
#' }
#' @name use_classification
NULL

modify_news <- function(dataset, contributor = NULL, issue = NULL) {
  usethis::edit_file("NEWS.md")
  msg <- format_message(dataset, contributor, issue)
  usethis::ui_code_block(msg)
}

format_message <- function(dataset, contributor, issue) {
  head <- glue("* New dataset `{dataset}_classification`")
  tail <- trimws(paste(contributor, issue))
  if (!is_empty(tail)) {
    tail <- paste0(" (", tail, ")", collapse = "")
  }
  paste0(head, tail, ".")
}

name_dataset <- function(prefix) {
  glue("{prefix}_classification")
}

format_helpfile <- function(dataset) {
  template <- c(
    "#' @inherit isic_classification title",
    "#' @inherit isic_classification description",
    "#'",
    "#' @section Definitions:",
    "#' `r define('%s')`",
    "#'",
    "#' @template info_classification-datasets",
    "#'",
    "#' @family datasets for bridging sector classification codes",
    "#' @seealso [data_dictionary].",
    "#'",
    "#' @examples",
    "#' head(%s)",
    "'%s'"
  )

  sprintf(template, dataset)
}

modify_r_classification_bridge <- function(dataset) {
  usethis::edit_file(file.path("R", "classification_bridge.R"))

  x <- paste0(format_helpfile(dataset), collapse = "\n")
  usethis::ui_code_block(x)
}

write_raw_data <- function(data, dataset) {
  file <- data_raw_path(dataset)
  readr::write_csv(data, file)
  ui_done("Writing `{dataset}` in {file}.")
  invisible(data)
}

data_raw_path <- function(dataset) {
  here::here("data-raw", glue::glue("{dataset}.csv"))
}

multiline_code_block <- function(string) {
  x <- paste0(string, collapse = "\n")
  usethis::ui_code_block(x)
}

format_use_data <- function(dataset) {
  template <- c(
    "%s <- read_csv_(",
    "  file.path('data-raw', '%s.csv')",
    ")",
    "usethis::use_data(%s, overwrite = TRUE)"
  )
  sprintf(template, dataset)
}

modify_data_raw_classification_bridge <- function(dataset) {
  edit_file(file.path("data-raw","classification_bridge.R"))

  lines <- format_use_data(dataset)
  multiline_code_block(lines)

  invisible(dataset)
}

data_dictionary_path <- function(dataset) {
  here::here("data-raw", "data_dictionary", glue("{dataset}.csv"))
}

format_data_dictionary_entry <- function(dataset) {
  template <- c(
    "dataset,column,typeof,definition",
    "%s,original_code,character,Original %s sector name",
    "%s,code_level,double,Level of granularity of %s code",
    "%s,code,double,Formatted %s code",
    "%s,sector,character,Associated 2dii sector",
    "%s,borderline,logical,Flag indicating if 2dii sector and classification code are a borderline match. The value TRUE indicates that the match is uncertain between the 2dii sector and the classification. The value FALSE indicates that the match is certainly perfect or the classification is certainly out of 2dii's scope."
  )
  sprintf(template, dataset, dataset)
}

new_data_dictionary_entry <- function(dataset) {
  path <- data_dictionary_path(dataset)
  edit_file(path)

  lines <- format_data_dictionary_entry(dataset)
  multiline_code_block(lines)
  ui_todo("Add, remove, or edit as necessary.")

  invisible(dataset)
}

modify_test_data_dictionary <- function(dataset) {
  path <- file.path("tests", "testthat", "test-data_dictionary.R")
  edit_file(path)

  template <- glue("expected_datasets <- c(expected_datasets, '{dataset}')")
  ui_code_block(template)

  invisible(dataset)
}
