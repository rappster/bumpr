#' @title
#' Bump Package Version Number
#'
#' @description 
#' Bumps an R package project to the next version number.
#' 
#' @details
#' Asumptions:
#' \itemize{
#'   \item{\strong{R package project}: } {
#'   
#'      You are using this function to systematically manage the versions 
#'      of an R package project that follows the official conventions
#'      (see \url{http://cran.r-project.org/doc/manuals/r-release/R-exts.html}.
#'   }
#' }
#' 
#' @details
#'      Retrieves the current package version from the \code{DESCRIPTION} file,
#'      suggest the next version number and prompts the user for a new 
#'      version number. After asking permission, the new version number is 
#'      written to the \code{DESCRIPTION} file along with additional
#'      information provided via \code{desc_fields}. Currently, only 
#'      an element of form \code{Date = NULL} is allowed/used, which 
#'      corresponds to also updating the \code{Date} field of the 
#'      \code{DESCRIPTION} file. \code{desc_fields = list()} suppresses that.
#'          
#'      Essentially, this function is a mere convenience wrapper for the 
#'      actual workhorse function \code{\link[bumpr]{bump}} and its 
#'      method associated to class \code{Bumpr.RPackageVersion.s3}.
#' 
#' @param .ns \strong{Signature argument}.
#'    Object containing namespace information.
#' @param taken \code{\link{character}}.
#'    Version numbers that are already taken. Usually, these are the Git 
#'    tags that correspond to release versions. If used in combination 
#'    with \code{\link{bump-Bumpr-Git.S3-character-character-method}}, this
#'    information is automatically retrieved.
#' @param desc_fields \code{\link{list}}.
#'    Additional fields (besides \code{Version}) in DESCRIPTION file that 
#'    should be updated with a version number bump. Specified as name-value pairs.
#' @template threedot
#' @example inst/examples/bumpPackageVersion.r
#' @seealso \code{
#'   	\link[bumpr]{bumpPackageVersion-RPackageVersion.S3-method},
#'     \link[bumpr]{bumpGitVersion}
#' }
#' @template author
#' @template references
#' @export 
setGeneric(
  name = "bumpPackageVersion",
  signature = c(
    ".ns"
  ),
  def = function(
    taken = character(),
    desc_fields = list("Date" = NULL),
    .ns = NULL,
    ...
  ) {
    standardGeneric("bumpPackageVersion")       
  }
)

#' @title
#' Bump Package Version Number
#'
#' @description 
#' See generic: \code{\link[bumpr]{bumpPackageVersion}}
#'      
#' @inheritParams bumpPackageVersion
#' @param .ns \code{\link{GitVersion.S3}}.
#' @return See method
#'    \code{\link[bumpr]{bumpPackageVersion-RPackageVersion.S3-method}}
#' @example inst/examples/bumpPackageVersion.r
#' @seealso \code{
#'    \link[bumpr]{bumpPackageVersion},
#'    \link[bumpr]{bumpPackageVersion-RPackageVersion.S3-method},
#'    \link[bumpr]{bumpGitVersion}
#' }
#' @template author
#' @template references
#' @export
setMethod(
  f = "bumpPackageVersion", 
  signature = signature(
    .ns = "missing"
  ), 
  definition = function(
    taken,
    desc_fields,
    .ns,
    ...
  ) {
    
  .ns <- bumpr::RPackageVersion.S3() 
  return(bumpPackageVersion(
    taken = taken,
    desc_fields = desc_fields,
    .ns = .ns,
    ...
  ))
  
  }
)

#' @title
#' Bump Package Version Number
#'
#' @description 
#' See generic: \code{\link[bumpr]{RPackageVersion.S3}}
#'   	 
#' @inheritParams bumpPackageVersion
#' @param .ns \code{\link{RPackageVersion.S3}}.
#' @return \code{\link{list}}. (\code{old} and \code{new} version number or 
#'    \code{list()} if the function exited before completing the bump.
#' @example inst/examples/bumpPackageVersion.r
#' @seealso \code{
#'    \link[bumpr]{bumpPackageVersion},
#'     \link[bumpr]{bumpGitVersion}
#' }
#' @template author
#' @template references
#' @export
setMethod(
  f = "bumpPackageVersion", 
  signature = signature(
    .ns = "RPackageVersion.S3"
  ), 
  definition = function(
    taken,
    desc_fields,
    .ns,
    ...
  ) {

  return(bump(
    what = .ns, 
    taken = taken, 
    desc_fields = desc_fields, 
    ...
  ))
    
  }
)
