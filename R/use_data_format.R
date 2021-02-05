#' Document datasets in r2dii.data::data_dictionary
#'
#' @param dataset Character string of length-1 giving the name of a dataset
#' in the column `datasets` of [r2dii.data::data_dictionary].
#'
#' @return Text output of class "glue".
#' @export
#'
#' @examples
#' use_data_format("region_isos")
use_data_format <- function(dataset) {
  glue::glue("#' @format")
  glue::glue("#' `{substitute(dataset)}` is a [data.frame] with columns:")

  dd <- r2dii.data::data_dictionary
  dd <- dd[dd$dataset == dataset, , drop = FALSE]
  dd$dataset <- NULL

  glue::glue_data(dd, "#' * `{column}` ({typeof}): {definition}.")
}
