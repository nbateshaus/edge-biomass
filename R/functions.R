# From https://github.com/charlotte-ngs/rmdhelp/blob/master/R/misc_helper.R
# (MIT Licensed)
get_this_rmd_file <- function() {
  # return the current rmd file depending on usage mode
  return(ifelse(rstudioapi::isAvailable(),
    normalizePath(rstudioapi::getSourceEditorContext()$path),
    whereami::thisfile()
  ))
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

biomass_AGBMg <- function(.data, spCoef) {
  .data |>
    left_join(spCoef |> select(!gesp), by = join_by(genspe)) |>
    mutate(AGBkg = case_when(
      formulaType == 1 ~ b1 * (dbh^b2),
      formulaType == 3 ~ exp(b1 + b2 * log(dbh)),
      formulaType == 5 ~ (b1 * (dbh^b2)) / 1000,
      formulaType == 7 ~ exp((b1 + b2 * log(dbh)) / 1000),
      gesp != "SNAG" ~ allodb::get_biomass(
        dbh,
        genus = GENUS,
        species = SPECIES,
        coords = c(-72.1899, 42.5319) # Harvard Forest
      )
    )) |>
    mutate(AGBMg = round(AGBkg / 1000, 3))
}

# Given the centerpoint of the edge edge [sic] of an
# edge plot, and the true-north aspect of the edge edge
# with CCW winding order (as standard for GeoJSON etc.),
# give back a three-subplot polygon.
edge_plot_poly <- function(cx, cy, aspect_deg, plot_id) {
  short <- 10 # short-axis length (m) - front edge
  long <- 30 # long-axis length (m) - plot depth
  n_sub <- 3 # number of subplots along the long axis

  # create rectangle in local coords, set origin at the front-edge midpoint:
  #   x = short axis (aligned with aspect), centered on 0
  #   y = long axis, running from 0 (edge) to `long` (far end)
  rect0 <- st_polygon(list(rbind(
    c(-short / 2, 0),
    c(short / 2, 0),
    c(short / 2, long),
    c(-short / 2, long),
    c(-short / 2, 0)
  )))

  # split the long axis into n_sub subplots
  subplots <- st_make_grid(rect0, n = c(1, n_sub))

  # rotation matrix for the (normalized) compass bearing

  # maps matrix maps local x (short axis) to point along the
  # compass bearing `theta`, and local y (long axis) to point
  # 90 degrees counter-clockwise from that bearing.
  theta <- aspect_deg * pi / 180
  R <- matrix(
    c(
      sin(theta), -cos(theta),
      cos(theta),  sin(theta)
    ),
    nrow = 2
  )

  # rotate + translate all geometries together in one step
  subs_map <- (subplots * R) + c(cx, cy)

  st_sf(
    plot_id    = plot_id,
    subplot_id = seq_len(n_sub),
    part       = paste0("subplot_", seq_len(n_sub)),
    geometry   = subs_map
  )
}
