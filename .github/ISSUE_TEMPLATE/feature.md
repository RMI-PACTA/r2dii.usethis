---
name: Feature
about: Request a feature or enhancement
title: ''
labels: feature
assignees: maurolepore

---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is. Ex. I'm always frustrated when [...]

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.

**Can you provide something like this?**

```
#' A title line, for example: Sum two numbers
#' 
#' One description paragraph. For example: This function sums two numbers. It
#' does nothing really useful other than showing how to document a function.
#'
#' Optionally, any number of paragraphs giving details. We follow the tidyverse
#' style guide: <https://style.tidyverse.org/>.
#' 
#' @param x Definition of the `x` argument. For example: A number.
#' @param y Definition of the `y` argument. For example: A number.
#'
#' @return What do you expect this function to return? For example: A number.
#' @export
#'
#' @examples
#' sum_two_numbers(1, 1)
sum_two_numbers <- function(x, y) {
  stopifnot(is.numeric(x), is.numeric(y))
  
  x + y
}
```
