#' A slim wrapper around `usethis::use_github_labels` to set standard labels 
#' and colours to any `r2dii` type github repository. I vaguely followed the 
#' style-guide found here: 
#' https://robinpowered.com/blog/best-practice-system-for-organizing-and-tagging-github-issues
#'
#'@inheritParams usethis::use_github_labels
#'
#' @export
#'
#' @examples
#' ## Not run:
#' use_r2dii_labels()
use_r2dii_labels <- function(delete_default = FALSE) {
 
  default_labels <- tibble::tribble(
    ~labels,  ~colours,                                         ~desc,
    "bug", "#B60205",                     "Something isn't working",
    "concept", "#0E8A16",                      "New concept/methdology",
    "documentation", "#FEF2C0",  "Improvements or additions to documentation",
    "duplicate", "#CFD3D7",   "This issue or pull request already exists",
    "enhancement", "#1D76DB",                      "New feature or request",
    "good first issue", "#5319E7",                          "Good for newcomers",
    "help wanted", "#FBCA04",                   "Extra attention is needed",
    "large", "#E99695",      "Likely will take over a week to finish",
    "medium", "#F9D0C4",             "Likely finished in under a week",
    "small", "#FBCA04", "This issue has a linked PBI on Azure DevOps",
    "on-ADO", "#B60205",                  "Needs to be addressed ASAP",
    "priority", "#FEF2C0",              "Likely finished in under a day",
    "wontfix", "#CFD3D7",                  "This will not be worked on"
  )
  
   usethis::use_github_labels(
     labels = default_labels$labels, 
     colours = default_labels$colours,
     descriptions = default_labels$desc,
     delete_default = delete_default
  )
  
}
