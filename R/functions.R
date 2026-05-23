# From https://github.com/charlotte-ngs/rmdhelp/blob/master/R/misc_helper.R
# (MIT Licensed)
get_this_rmd_file <- function(){
  # return the current rmd file depending on usage mode
  return(ifelse(rstudioapi::isAvailable(),
                normalizePath(rstudioapi::getSourceEditorContext()$path),
                whereami::thisfile()))
}

tar_objects_defined_in_rmd <- function(filename) {
  read_lines(filename) |>
    # Find targets code blocks
    grepv("^```\\{targets ", x = _) |>
    # Parse out the names of those blocks
    sub("^[^ ]+ ([^,}]+).*", "\\1", x = _) |>
    # globals is not a legit target; remove it
    grepv("^globals$", x = _, invert = TRUE)
}
