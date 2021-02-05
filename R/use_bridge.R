#' Use a new sector-classification bridge in r2dii.data
#'
#' @param dataset String. Name of the dataset, to be used as the prefix of an
#'   object with the format `[prefix]_classification`, e.g.
#'   `psic_classification`.
#' @param data A data frame.
#' @param contributor String. Name of a contributor to thank in NEWS.md, e.g.
#'   "\@daisy-pacheco".
#' @param issue String. Number of related issue or PR, e.g. #199.
#' @param overwrite Logical. Allow overwriting data?
#'
#' @return Most functions are interactive, and called for their side effects.
#' The return value is usually `invisible(dataset)`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Setup -------------------------------------------------------------------
#' # Work form inside r2dii.data
#' fs::dir_copy("../r2dii.data", tempdir())
#' tmp <- fs::path(tempdir(), "r2dii.data")
#' old <- getwd()
#' setwd(tmp)
#'
#' # Call use_bridge ---------------------------------------------------------
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
#' unlink(tmp, recursive = TRUE)
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

bridge_update_r <- function(dataset) {
  path <- file.path("R", "classification_bridge.R")
  append_with(dataset, fun = format_helpfile, path = path)

  invisible(dataset)
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

bridge_update_data_raw <- function(dataset) {
  path <- file.path("data-raw", "classification_bridge.R")
  append_with(dataset, fun = format_use_data, path = path)

  invisible(dataset)
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

bridge_add_dictionary <- function(dataset, overwrite = FALSE) {
  file <- data_dictionary_path(dataset)
  stopifnot_new(file, overwrite)
  stopifnot_has_bridge_cols(dataset)

  message("Writing:", file)
  lines <- format_data_dictionary_entry(dataset)
  writeLines(lines, file)

  invisible(dataset)
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

bridge_todo <- function() {
  glue('
    TODO:
      test()
      snapshot_accept("sector_classifications")
      snapshot_accept("data_dictionary")
      test()
  ')
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
