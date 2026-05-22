tar_terra_vect(
  rope_plots,
  readxl::read_xls(
    rope_plots_file,
    sheet = "Rope Plot Sites"
  ) |>
    mutate(
      lat = as.numeric(gsub("^N ?([^°]+)°.*$", "\\1", GPS)),
      lon = -as.numeric(gsub("^.*W ?([^°]+)°$", "\\1", GPS))
    ) |>
    terra::vect()
)
