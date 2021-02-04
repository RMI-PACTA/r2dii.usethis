#' Use a new sector-classification bridge in r2dii.data
#'
#' @param dataset String. Name of the new classification dataset you want to
#'   add, with the format `[prefix]_classification`, e.g. `psic_classification`.
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
#' # This is an internal function aimed at developers
#' load_all()
#'
#' # The source code does not ship with the package to avoid dependencies
#' source_use_bridge()
#'
#' # This is usually a contributed spreadsheet
#' data <- r2dii.data::psic_classification
#'
#' # The dataset name must have the format [prefix]_classificaton
#' dataset
#'
#' contributor <- "@somebody"
#' issue <- "#123"
#'
#' use_bridge(dataset, data, contributor, issue, overwrite = TRUE)
#' }
use_bridge <- function(dataset,
                       data,
                       contributor = NULL,
                       issue = NULL,
                       overwrite = FALSE) {
  dataset <- name_dataset(dataset)
  
  bridge_write_raw_data(dataset, data, overwrite = overwrite)
  bridge_add_dictionary(dataset, overwrite = overwrite)
  bridge_update_news(dataset, contributor = contributor, issue = issue)
  bridge_update_r(dataset)
  bridge_update_data_raw(dataset)
  suppressMessages(source_data_raw())
  test_quietly()
  bridge_update_snapshots()
  test_quietly()

  invisible(dataset)
}

test_quietly <- function() {
  suppressMessages(test(reporter = ""))
}

#' @rdname use_bridge
#' @export
bridge_update_news <- function(dataset, contributor = NULL, issue = NULL) {
  path <- here::here("NEWS.md")
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

#' @rdname use_bridge
#' @export
name_dataset <- function(prefix) {
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

#' @rdname use_bridge
#' @export
bridge_update_r <- function(dataset) {
  path <- here("R", "classification_bridge.R")
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

#' @rdname use_bridge
#' @export
bridge_write_raw_data <- function(dataset, data, overwrite = FALSE) {
  file <- data_raw_path(dataset)
  stopifnot_new(file, overwrite)

  msg <- sprintf("Writing `%s` in %s.", dataset, file)
  message(msg)
  readr::write_csv(data, file)

  invisible(data)
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
  here::here("data-raw", glue("{dataset}.csv"))
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

#' @rdname use_bridge
#' @export
bridge_update_data_raw <- function(dataset) {
  path <- here("data-raw","classification_bridge.R")
  append_with(dataset, fun = format_use_data, path = path)

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

#' @rdname use_bridge
#' @export
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
  actual <- names(utils::read.csv(raw_data, nrows = 1L))
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

#' @rdname use_bridge
#' @export
bridge_update_snapshots <- function() {
  snapshot_accept("sector_classifications")
  snapshot_accept("data_dictionary")
}
