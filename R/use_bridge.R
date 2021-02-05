#' Use a new sector-classification bridge in r2dii.data
#'
#' This is a developer-facing function that helps create the pull request you
#' need to add a new sector-classification bridge to the package r2dii.data
#' ([example](https://github.com/2DegreesInvesting/r2dii.data/pull/200)). It
#' does create a commit but it does change your working tree: It adds new files
#' and modifies existing files. If the result is now what you want, you may
#' restore the last commit with something like `git checkout . && git clean -i`.
#' Normally you would call this function from inside the project that contains
#' the source code of the package r2dii.data.
#'
#' @param dataset String. Name of the dataset. This is used as the "prefix" to
#'   for an object-name of the form `[prefix]_classification`, e.g.
#'   `psic_classification`.
#' @param data A data frame.
#' @param contributor String. Name of a contributor to thank in NEWS.md, e.g.
#'   "\@daisy-pacheco".
#' @param issue String. Number of related issue or PR, e.g. #199.
#' @param overwrite Logical. Allow overwriting data?
#'
#' @return This function is called for its side effects of adding and modifying
#'   files. It returns the first argument invisibly.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Work form inside r2dii.data (here I use from a temporary copy)
#' old <- getwd()
#' r2dii_data <- file.path(tempdir(), "r2dii.data")
#' fs::dir_create(r2dii_data)
#' setwd(r2dii_data)
#' system("git clone https://github.com/2DegreesInvesting/r2dii.data.git -- .")
#' devtools::load_all()
#'
#' library(r2dii.usethis)
#'
#' # This is usually a contributed spreadsheet
#' dataset <- "fake"
#' data <- data.frame(
#'   original_code = letters[1:3],
#'   code_level = 5,
#'   code = as.character(1:3),
#'   sector = "not in scope",
#'   borderline = FALSE
#' )
#' contributor <- "@somebody"
#' issue <- "#123"
#' use_bridge(dataset, data, contributor, issue)
#'
#' # Notice what changed
#' system("git status -s")
#'
#' # Teardown ----------------------------------------------------------------
#' unlink(r2dii_data, recursive = TRUE)
#' setwd(old)
#' }
use_bridge <- function(dataset,
                       data,
                       contributor = NULL,
                       issue = NULL,
                       overwrite = FALSE) {
  dataset <- bridge_name(dataset)
  bridge_write_raw_data(dataset, data, overwrite = overwrite)
  bridge_add_dictionary(dataset, overwrite = overwrite)
  bridge_update_news(dataset, contributor = contributor, issue = issue)
  bridge_update_r(dataset)
  bridge_update_data_raw(dataset)

  refresh_data()
  message(bridge_todo())

  invisible(dataset)
}

bridge_name <- function(prefix) {
  prefix <- tolower(prefix)
  has_underscore <- grepl("_", prefix)

  if (has_underscore) {
    stop(
      "`prefix` '", prefix, "' must not contain unterscore '_'.",
      call. = FALSE
    )
  }

  glue("{prefix}_classification")
}

bridge_write_raw_data <- function(dataset, data, overwrite = FALSE) {
  file <- data_raw_path(dataset)
  stopifnot_new(file, overwrite)

  msg <- sprintf("Writing `%s` in %s.", dataset, file)
  message(msg)
  write.csv(data, file, row.names = FALSE)

  invisible(data)
}

bridge_add_dictionary <- function(dataset, overwrite = FALSE) {
  file <- data_dictionary_path(dataset)
  stopifnot_new(file, overwrite)
  stopifnot_has_bridge_cols(dataset)

  message("Writing:", file)
  lines <- format_data_dictionary_entry(dataset)
  writeLines(lines, file)

  invisible(dataset)
}

bridge_update_news <- function(dataset, contributor = NULL, issue = NULL) {
  path <- file.path("NEWS.md")
  old <- readLines(path)

  old_head <- old[1]
  old_tail <- old[2:length(old)]
  update <- format_new_bridge_news(dataset, contributor, issue)
  news <- c(old_head, "", update, old_tail)

  message("Updating ", path)
  writeLines(news, path)

  invisible(dataset)
}

bridge_update_r <- function(dataset) {
  path <- file.path("R", "classification_bridge.R")
  append_with(dataset, fun = format_helpfile, path = path)

  invisible(dataset)
}

bridge_update_data_raw <- function(dataset) {
  path <- file.path("data-raw", "classification_bridge.R")
  append_with(dataset, fun = format_use_data, path = path)

  invisible(dataset)
}

refresh_data <- function() {
  # One known warning is particularly annoying
  suppressWarnings(
    # Avoid clutter
    suppressMessages(
      source_data_raw()
    )
  )
}

bridge_todo <- function() {
  txt <- c(
    "TODO:",
    "  devtools::test()",
    "  testthat::snapshot_accept('sector_classifications')",
    "  testthat::snapshot_accept('data_dictionary')",
    "  devtools::test()"
  )

  format_line(txt)
}

format_line <- function(x) paste0(x, collapse = "\n")

format_new_bridge_news <- function(dataset, contributor, issue) {
  head <- glue("* New dataset `{dataset}_classification`")
  tail <- trimws(paste(contributor, issue))
  if (!is_empty(tail)) {
    tail <- paste0(" (", tail, ")", collapse = "")
  }
  paste0(head, tail, ".")
}

is_empty <- function(x) {
  length(x) == 0L
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


append_with <- function(dataset, fun, path) {
  old <- readLines(path)
  new <- fun(dataset)
  out <- c(old, "", new)

  message("Writing ", path)
  writeLines(out, path)

  invisible(dataset)
}

stopifnot_new <- function(file, overwrite) {
  new_file <- !file.exists(file)
  if (!new_file && !overwrite) {
    stop(
      "`file` must be new but it already exists:", "\n",
      file, "\n",
      "Do you need `overwrite = TRUE`?",
      call. = FALSE
    )
  }
}

data_raw_path <- function(dataset) {
  file.path("data-raw", glue("{dataset}.csv"))
}

format_use_data <- function(dataset) {
  template <- c(
    "%s <- read_csv_(",
    "  file.path('data-raw', '%s.csv')",
    ")",
    "use_data(%s, overwrite = TRUE)"
  )
  sprintf(template, dataset)
}

data_dictionary_path <- function(dataset) {
  file.path("data-raw", "data_dictionary", glue("{dataset}.csv"))
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

stopifnot_has_bridge_cols <- function(dataset) {
  raw_data <- data_raw_path(dataset)
  actual <- names(read.csv(raw_data, nrows = 1L))
  expected <- bridge_cols()

  has_bridge_cols <- identical(expected, actual)
  if (!has_bridge_cols) {
    stop(
      "Raw data must have expected columns.", "\n",
      "Bad file: ", raw_data, "\n",
      "Actual columns: ", commas(actual), "\n",
      "Expected columns: ", commas(expected), "\n",
      call. = FALSE
    )
  }

  invisible(dataset)
}

commas <- function(x) {
  paste(x, collapse = ", ")
}

bridge_cols <- function() {
  c("original_code", "code_level", "code", "sector", "borderline")
}
