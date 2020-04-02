#' Output 2DII's blue logo on a white background.
#' 
#' 
#' @source Uploaded to imgur from the file "2DII-Logo-Blue-1000px.png" accessed
#'   from 2DII's dropbox folder on 2020-04-02.
#' 
#' @param package String of length-1 giving the name of the package to which you
#'   want to add the logo.
#'   
#' @return `NULL` as it is called for it's side effect.
#' @export
#'
#' @examples
#' use_2dii_logo()
use_2dii_logo <- function(package) {
  glue::glue(
    "Add logo to your README with the following html:
      # {package} <a href='https://github.com/2DegreesInvesting/{package}'>\\
      <img src='https://imgur.com/A5ASZPE.png' align='right' height='43' /></a>"
  )
}
