# set up function for converting DMS coordinates to DD format
dms_to_dd <- function(x) {
  x <- toupper(trimws(as.character(x)))
  
  out <- vapply(x, function(val) {
    if (is.na(val) || val == "") return(NA_real_)
    
    # handle already plain decimal degrees
    if (grepl("^-?[0-9]+\\.?[0-9]*$", val)) {
      return(as.numeric(val))
    }
    
    # handle hemisphere letters if present
    hemi_match <- regmatches(val, regexpr("[NSEW]", val))
    hemi <- if (length(hemi_match) > 0 && nchar(hemi_match) > 0) hemi_match else NA_character_
    
    # handle all numeric tokens in order
    nums <- as.numeric(regmatches(val, gregexpr("[0-9]+\\.?[0-9]*", val))[[1]])
    if (length(nums) == 0) return(NA_real_)
    
    deg <- nums[1]
    mins <- if (length(nums) >= 2) nums[2] else 0
    secs <- if (length(nums) >= 3) nums[3] else 0
    
    dd <- deg + mins / 60 + secs / 3600
    
    if (!is.na(hemi) && hemi %in% c("S", "W")) dd <- -dd
    if (is.na(hemi) && grepl("^-", val)) dd <- -dd
    
    dd
  }, numeric(1), USE.NAMES = FALSE)
  
  bad <- which(is.na(out) & !is.na(x) & x != "")
  if (length(bad) > 0) {
    warning("Could not parse ", length(bad), " coordinate(s). ",
            "Raw values: ", paste(x[bad], collapse = " | "))
  }
  
  out
}
