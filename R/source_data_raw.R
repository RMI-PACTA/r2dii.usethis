#' Source all .R files under data-raw/
#'
#' Usually we work on one dataset only, and don't know if our change impacted
#' other datasets. This function helps "refresh" all datasets at once. It may
#' be used interactively while developing the package, or in CI to regularly
#' check we can reproduce all datasets we export, and that the result is
#' consistent with our regression tests.
#' 
#' @param path String. Path in the working directory.
#' @return `invisible(path)`, as it's called for its side effect.
#'
#' @export
#' 
#' @examples
#' source_data_raw()
source_data_raw <- function(path = "data-raw") {
  lapply(r_files_in(path), source)

  invisible(path)
}

r_files_in <- function(path) {
  # pattern = "[.]R$" is simpler but platform-inconsistent, e.g. "a//b", "a/b".
  path_ext <- list.files(path, pattern = NULL, full.names = TRUE)
  grep("[.]R$", path_ext, value = TRUE)
}
