% Generated by roxygen2 (4.0.2): do not edit by hand
\docType{methods}
\name{bumpGitVersion,missing-method}
\alias{bumpGitVersion,missing-method}
\title{Bump Git Version Number}
\usage{

  \S4method{bumpGitVersion}{missing}(project = devtools::as.package(".")$package,
  temp_credentials = FALSE, .ns = NULL, ...)
}
\arguments{
\item{project}{\code{\link{character}}.
Name of the project under Git version control.}

\item{temp_credentials}{\code{\link{logical}}.
\code{TRUE}: delete HTTPS credentials after each bump;
\code{FALSE}: permanently store HTTPS credentials in \code{_netrc} file.
See details.}

\item{.ns}{\code{\link{GitVersion.S3}}.}

\item{...}{Further arguments to be passed to subsequent functions/methods.}
}
\value{
See method
   \code{\link[bumpr]{bumpGitVersion-GitVersion.S3-method}}
}
\description{
See generic: \code{\link[bumpr]{bumpGitVersion}}
}
\examples{
\dontrun{

##------------------------------------------------------------------------------
## DISCLAIMER  
##------------------------------------------------------------------------------

## Please that with repositories that are not crucial for your productive work!

## Make sure that you set your working directory to your package
## project's root directory and that you've read and understood the 
## assumptions that this function makes!
  
bumpGitVersion()

}
}
\author{
Janko Thyson \email{janko.thyson@gmail.com}
}
\references{
\url{http://github.com/jankothyson/bumpr}
}
\seealso{
\code{
   \link[bumpr]{bumpGitVersion},
   \link[bumpr]{bumpGitVersion-GitVersion.S3-method},
   \link[bumpr]{bumpPackageVersion}
}
}

