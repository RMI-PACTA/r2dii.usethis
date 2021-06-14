#' Add default r2dii github issue labels to the active repository 
#' 
#' A slim wrapper around `usethis::use_github_labels` to set standard labels
#' and colours to any `r2dii` type github repository. I vaguely followed the
#' style-guide found [here](https://robinpowered.com/blog/best-practice-system-for-organizing-and-tagging-github-issues).
#'
#' @inheritParams usethis::use_github_labels
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   use_r2dii_labels()
#' }
use_r2dii_labels <- function(delete_default = FALSE) {
  
  labels <- c(
    "bug",
    "concept", 
    "documentation", 
    "duplicate", 
    "enhancement", 
    "good first issue", 
    "help wanted", 
    "large", 
    "medium", 
    "small", 
    "on-ADO", 
    "priority", 
    "wontfix"
  )

  colours <- c(
    "bug" = "B60205",
    "concept" = "0E8A16", 
    "documentation" = "D4C5F9", 
    "duplicate" = "CFD3D7", 
    "enhancement" = "1D76DB", 
    "good first issue" = "5319E7", 
    "help wanted" = "FBCA04", 
    "large" = "E99695", 
    "medium" = "F9D0C4", 
    "small" = "FEF2C0", 
    "on-ADO" = "FBCA04", 
    "priority" = "B60205",
    "wontfix" = "CFD3D7"
    )
  
  descriptions <- c(
    "bug" = "Something isn't working", 
    "concept" = "New concept/methdology", 
    "documentation" =  "Improvements or additions to documentation", 
    "duplicate" = "This issue or pull request already exists", 
    "enhancement" = "New feature or request", 
    "good first issue" = "Good for newcomers", 
    "help wanted" = "Extra attention is needed", 
    "large" =  "Likely will take over a week to finish",
    "medium" = "Likely finished in under a week",
    "small" =     "Likely finished in under a day",  
    "on-ADO" = "This issue has a linked PBI on Azure DevOps", 
    "priority" = "Needs to be addressed ASAP",
    "wontfix" = "This will not be worked on"
  )
    
  usethis::use_github_labels(
    labels = labels,
    colours = colours,
    descriptions = descriptions,
    delete_default = delete_default
  )
}
