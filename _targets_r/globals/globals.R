options(tidyverse.quiet = TRUE)
tar_option_set(
  packages = c(
    "tarchetypes",
    "tidyverse",
    "terra",
    "tidyterra",
    "geotargets",
    "sf",
    "sfheaders",
    "gdalUtilities"
  )
)
tar_source()
