#' Use GitHub actions for packages
#' 
#' This function configures GitHub actions to check your package, build its 
#' website, and deploy it to gh-pages. By default, examples don't run. This is
#' to avoid accidentally showing private data in examples. If you do want to 
#' run examples, edit ".github/workflows/main.yml" and replace 
#' `pkgdown::build_site(examples = FALSE)` with 
#' `pkgdown::build_site(examples = TRUE)`.
#' 
#' @section Setup:
#' 
#' * Setup secrets at Settings > Secrets (available only if you have access to GitHub Actions):
#'     * You need `GH_PAT` for GitHub actions
#'     (<https://github.com/maxheld83/ghpages#secrets>).
#'     * If your package needs to access private repos, also add your
#'     `GITHUB_PAT`.
#' 
#' * Use pkgdown with [usethis::use_pkgdown()] or from 2dii's template:
#' 
#' ```
#' usethis::use_template("_pkgdown.yml", package = "r2dii.usethis")
#' ```
#' 
#' * Create the gh-pages branch from the terminal (instructions from [pkgdown::deploy_site_github()]):
#' 
#' ```
#' git checkout --orphan gh-pages
#' git rm -rf .
#' git commit --allow-empty -m 'Initial gh-pages commit'
#' git push origin gh-pages
#' git checkout master
#' ```
#'
#' @return Invisible `NULL`.
#' @export
#' 
#' @seealso [usethis::use_pkgdown()], [pkgdown::deploy_site_github()].
#'
#' @examples
#' \dontrun{
#' use_pkg_actions()
#' }
use_pkg_actions <- function() {
  usethis::use_directory(".github", ignore = TRUE)
  usethis::use_directory(".github/workflows")
  usethis::use_template(
    "main.yml", ".github/workflows/main.yml", package = "r2dii.usethis"
  )
  
  invisible()
}
