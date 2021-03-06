bumpr
======

Systematic version bumping and more

## Installation

```
require("devtools")
devtools::install_github("Rappster/bumpr")
require("bumpr")
```

## Overview

See `?bumpr` for the overall purpose of this package.

## Semantic versioning

The package's versioning scheme is based on the paradigm of [semantic versioning](http://semver.org/).

## Bump R package version (no Git required)

Retrieves the current package version from the `DESCRIPTION` file, suggests the next version number and prompts the user for a new version number. After asking permission, the new version number is written to the `DESCRIPTION` file along with the additional information provided via `desc_fields`. Currently, only an element of form `Date = NULL` is allowed/used, which corresponds to also updating the `Date` field of the `DESCRIPTION` file to the current system time. Setting `desc_fields = list()` suppresses that.

### Example

Bumping from current version `0.5` to a new version

```
bumpPackageVersion()

# Taken versions numbers (last 10): 
# 0.3.8
# 0.3.9
# 0.3.10
# 0.3.11
# 0.3.12
# 0.3.13
# 0.3.14
# 0.4
# 0.4.1
# 0.4.2
# 0.5
# Current version: 0.5
# Suggested version: 0.6
# Enter a valid version number: [ENTER = 0.6] 
# Using suggested version: 0.6
# Updating version in DESCRIPTION file to '0.6?' [(y)es | (n)o | (q)uit]: 
# $old
# [1] "0.5"
# 
# $new
# [1] "0.6"
```

#### Explanation what just happened

- The suggestion always takes the last version digit and increments it by one.
If you simply hit enter, this suggested version will be used. 

  However, you are of course free to provide any version you'd like as long as
it complies with the [semtatic versioning conventions](http://semver.org/).

- You are then asked if you want to update your `DESCRIPTION` file (currently updated fields: `Version` and `Date`).

- The function returns the old and new version as a `list`. If
along the way something when wrong (wrong user input) or when you wanted to quit on purpose, the function returns `list()`.

  In this case, all changes are rolled back (see section *Rollback behavior*).

## Bump Git version 

Performs all sorts of Git-related checks and tasks in order to take care
that everything necessary is done that is related to bumping a project
to a higher version number.
 
This provided version number is transferred to `v{version-number}`,
e.g. `v0.1.1`, and added as a Git tag. 

All commits linked to the *previous* version/tag are queried and added
to file `CHANGES.md`. Additionally, a template section to state the 
changes in the *new* version is added in file `NEWS.md`.

Files `DESCRIPTION` and `CHANGES.md` are automatically 
commited to signal the version bump.

Per default, the function expects that you want to include a remote repository in the version bump (default: `origin`). This can be any valid Git remote repository, including a GitHub repository. In this case the bump commit as well as the new version (i.e. the new tag) are pushed to the remote repository as well. You can, however, also choose to only work with your local Git repository (**not recommended**). Simply answer the first question accordingly.

### NOTE
**Please read the assumptions and recommendations stated in `?bumpGitVersion`
before running this function!**

Differentiate use cases:

1. Calling `bumpPackageVersion()` prior to calling `bumpGitVersion()`

  In this case, you most likely *do not*  want to bump to yet another version, so you should **stay** at the version you bumped to via `bumpPackageVersion()`, i.e. re-type the old version number instead of using the suggested incremented version number.

  `bumpPackageVersion()` is called inside of `bumpGitVersion()`, so bumping to a new version number again would be misleading. I hope to be able to implement an automatic detection for this in a future release.

2. Calling `bumpGitVersion()` without prior calling of `bumpPackageVersion()`

  **This is the recommended way of using this function when version-controlling your package project with Git. Make your version specification as you see fit.**

### Example: with remote repository

The example assumes that `bumpGitVersion()` is called without previously having called `bumpPackageVersion()` explicitly and that a remote repository should be included in the version bump.

```
bumpGitVersion()

# Would you like to include a remote repository? [(y)es | (n)o | (q)uit]: 
# Taken versions numbers (last 10): 
# 0.3.8
# 0.3.9
# 0.3.10
# 0.3.11
# 0.3.12
# 0.3.13
# 0.3.14
# 0.4
# 0.4.1
# 0.4.2
# 0.5
# Current version: 0.5
# Suggested version: 0.6
# Enter a valid version number: [ENTER = 0.6] 
# Using suggested version: 0.6
# Updating version in DESCRIPTION file to '0.6?' [(y)es | (n)o | (q)uit]: 
# Ready to bump version in git?' [(y)es | (n)o | (q)uit]: 
# Name of remote git repository (hit ENTER for default = 'origin'): 
# Using remote git repository: origin
# Git 'user.email' and 'user.name': global or local? [(g)lobal | (l)ocal | (q)uit ]: 
# Use PAT or 'basic' HTTPS authentication? [(p)at | (b)asic | (q)uit ]: 
# Show current PAT to verify its correctness? [(n)o | (y)es | (q)uit]: y
# Current PAT: {pat-value}
# Change current PAT? [(y)es | (n)o | (q)uit]: n
# 
# [release-0.6 b66874e] Version bump to 0.6 2 files changed, 14 insertions(+), 5 deletions(-)
# 
# To https://github.com/Rappster/bumpr * [new tag]         v0.6 -> v0.6
# $old
# [1] "0.5"
# 
# $new
# [1] "0.6"
# 
# $git_tag
# [1] "v0.6"
```

#### Explanation what just happened

- You are first asked if a remote repository should be included or not. 

- The suggestion for the new version always takes the last version digit and increments it by one. If you simply hit enter, this suggested version will be used. 

  However, you are of course free to provide any version you like as long as
it complies with the [semtatic versioning conventions](http://semver.org/).

- You are then asked if you want to update your `DESCRIPTION` file (currently updated fields: `Version` and `Date`).

- Then a last check before commencing with Git/GitHub related stuff is made.

- Based on the specification of your remote repository (**note that it is recommended to define it prior to running `bumpGitVersion()` but it can also be set by the function in case it has not been defined yet**) a new commit
is issued and **after** that a new tag corresponding to `v{new-version}` (e.g. `v0.5`) is created so **future** commits are automatically tagged with it.

- What also happens is that the files `CHANGES.md` and `NEWS.md` are updated
  as described in `?bumpr`.

- Before pushing to the remote (GitHub) repository, you are asked which form of HTTPS authentication you'd like to use: `PAT` ([Personal Access Token](https://github.com/blog/1509-personal-api-tokens) or [OAuth token](http://en.wikipedia.org/wiki/OAuth)) or `Basic`.

  - if choosing `PAT` (recommended):
  
    If your PAT has not been set as an environment variable yet (`GITHUB_PAT` following the convention introduced by package [`devtools`](https://github.com/hadley/devtools)), you are asked to do so. 
    
    Otherwise you are asked if you would like to review the currently set PAT. In this case you are also asked if you would like to change the PAT (in case the current PAT is wrong/outdated).
  
  - if choosing `Basic`
  
    Your credentials can either be looked in file `_netrc` in your `HOME` directory or you can typing it into the console. 

    This is also where argument `temp_credentials` comes into play: when `TRUE`
  the function makes sure that file `_netrc` is deleted after the version bump is
  finished.

  - If your remote repository does not require HTTPS authentication, simply hit `ENTER`.

- The function returns the old and new version and the Git tag as a `list`. If
along the way something when wrong (wrong user input) or when you wanted to quit on purpose, the function returns `list()`. 

  Note that in this case, all changes are rolled back (see section *Rollback behavior*)

### Example: without remote repository

The behavior is analogous to that above except everthing that only has to do with remote repositories. 

```
# Would you like to include a remote repository? [(y)es | (n)o | (q)uit]: n
# Taken versions numbers (last 10): 
# 0.3.8
# 0.3.9
# 0.3.10
# 0.3.11
# 0.3.12
# 0.3.13
# 0.3.14
# 0.4
# 0.4.1
# 0.4.2
# 0.5
# Current version: 0.5
# Suggested version: 0.6
# Enter a valid version number: [ENTER = 0.6] 
# Using suggested version: 0.6
# Updating version in DESCRIPTION file to '0.7?' [(y)es | (n)o | (q)uit]: 
# Ready to bump version in git?' [(y)es | (n)o | (q)uit]: 
#
# [release-0.6 b66874e] Version bump to 0.6 2 files changed, 14 insertions(+), 5 deletions(-)
# 
# To https://github.com/Rappster/bumpr * [new tag]         v0.6 -> v0.6
# $old
# [1] "0.5"
# 
# $new
# [1] "0.6"
# 
# $git_tag
# [1] "v0.6"
```

## Rollback behavior

### bumpPackageVersion()

If something should go wrong in `bumpPackageVersion()`, the function takes care
of rolling back all changes to `DESCRIPTION` that might have been made.

#### Example: intentional error

```
bumpPackageVersion()

# Taken versions numbers (last 10): 
# 0.3.7
# 0.3.8
# 0.3.9
# 0.3.10
# 0.3.11
# 0.3.12
# 0.3.13
# 0.3.14
# 0.4
# 0.4.1
# 0.4.2
# Current version: 0.4.2
# Suggested version: 0.4.3
# Enter a valid version number: [ENTER = 0.4.3] 0.5
# Updating version in DESCRIPTION file to '0.5?' [(y)es | (n)o | (q)uit]: 
# Rolling back changes in 'DESCRIPTION'
# Error in doTryCatch(return(expr), name, parentenv, handler) : 
#   Intentional error for unit testing
```

### bumpGitVersion()

If the use decides to quit a version bump or in case anything should go wrong in `bumpGitVersion()`, the function takes care or rolling back all changes:

1. Changes in `DESCRIPTION`
2. Changes in `CHANGES.md`
3. Changes in `NEWS.md`
4. Last Git commit corresponding to the version bump 
5. Git tag that was associated to the new version 

#### Example: intentional quit

```
bumpGitVersion()

# Would you like to include a remote repository? [(y)es | (n)o | (q)uit]:
# Taken versions numbers (last 10): 
# 0.3.7
# 0.3.8
# 0.3.9
# 0.3.10
# 0.3.11
# 0.3.12
# 0.3.13
# 0.3.14
# 0.4
# 0.4.1
# 0.4.2
# Current version: 0.4.2
# Suggested version: 0.4.3
# Enter a valid version number: [ENTER = 0.4.3] 0.5
# Updating version in DESCRIPTION file to '0.5?' [(y)es | (n)o | (q)uit]: 
# Ready to bump version in git?' [(y)es | (n)o | (q)uit]: q
# Rolling back changes in 'DESCRIPTION'
# Quitting
# list()
```

#### Example: intentional error before pushing to remote

```
bumpGitVersion()

# Would you like to include a remote repository? [(y)es | (n)o | (q)uit]:
# Taken versions numbers (last 10): 
# 0.3.7
# 0.3.8
# 0.3.9
# 0.3.10
# 0.3.11
# 0.3.12
# 0.3.13
# 0.3.14
# 0.4
# 0.4.1
# 0.4.2
# Current version: 0.4.2
# Suggested version: 0.4.3
# Enter a valid version number: [ENTER = 0.4.3] 0.5
# Updating version in DESCRIPTION file to '0.5?' [(y)es | (n)o | (q)uit]: 
# Ready to bump version in git?' [(y)es | (n)o | (q)uit]: 
# Name of remote git repository (hit ENTER for default = 'origin'): 
# Using remote git repository: origin
# Use PAT or 'basic' HTTPS authentication? [(p)at | (b)asic | (q)uit]: 
# Show current PAT to verify its correctness? [(n)o | (y)es | (q)uit]: 
# 
# [release-0.5 e9ad11d] Version bump to 0.5 2 files changed, 14 insertions(+), 5 deletions(-)
#
# Version bump failed
# Rolling back changes in 'DESCRIPTION'
# Rolling back changes in 'CHANGES.md'
# Rolling back changes in 'NEWS.md'
# Rolling back bump commit
# Unstaged changes after reset:M  NEWS.mdM	R/bump.rM	README.md
# Rolling back Git tags
# Deleted tag 'v0.5' (was ebda564)
# To https://github.com/Rappster/bumpr
#  - [deleted]         v0.5
# Error in doTryCatch(return(expr), name, parentenv, handler) : 
#   Intentional error for unit testing
# Git command: git push https://github.com/Rappster/bumpr --tags
```

-----

## Classes and constructors

### Class `GitVersion.S3`

Formal use

```
bumpr::GitVersion.S3()

# $version
# character(0)
# 
# $remote_name
# character(0)
# 
# $remote_url
# character(0)
# 
# $user_email
# character(0)
# 
# $user_name
# character(0)
# 
# attr(,"class")
# [1] "GitVersion.S3" "list"   
```

Informal use

```
bumpr::GitVersion.S3("0.1.1")

# [1] "0.1.1"
# attr(,"class")
# [1] "GitVersion.S3" "character"    
```

### Class `RPackageVersion.S3`

Formal use

```
bumpr::RPackageVersion.S3()

# $version
# character(0)
# 
# $lib
# character(0)
# 
# $path
# character(0)
# 
# attr(,"class")
# [1] "RPackageVersion.S3" "list"   
```

Informal use

```
bumpr::RPackageVersion.S3("0.1.1")

# [1] "0.1.1"
# attr(,"class")
# [1] "RPackageVersion.S3" "character"   
```

### Class `SystemState.S3`

Formal use

```
bumpr::SystemState.S3(
  ask_authentication = TRUE,
  branch = "master",
  cmd_user_email = "git config --global user.email",
  cmd_user_name = "git config --global user.name",
  description_old = as.list(read.dcf("DESCRIPTION")[1,]),
  git_tag = "v1.1.2",
  git_user_email = "janko.thyson@rappster.de",
  git_user_name = "Janko Thyson",
  global_or_local = "global",
  has_remote = TRUE,
  pat_or_basic = "pat",
  path_netrc = file.path(Sys.getenv("HOME"), "_netrc"),
  path_netrc_tmp = file.path(Sys.getenv("HOME"), "_netrc_0"),
  quit = FALSE,
  remote = "origin",
  remote_all = list(origin = character()),
  remote_name = "origin",
  remote_url = "https://github.com/Rappster/bumpr",
  temp_credentials = FALSE,
  what = bumpr::GitVersion.S3()
)

# <environment: 0x000000000f9d3e60>
# attr(,"class")
# [1] "SystemState.S3" "environment"   
```

Informal use 

```
bumpr::SystemState.S3(TRUE)

# [1] TRUE
# attr(,"class")
# [1] "SystemState.S3" "logical"  
```
