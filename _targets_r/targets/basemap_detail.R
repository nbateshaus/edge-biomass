tar_terra_rast(
  basemap_detail,
  {
    detail_area <- terra::ext(-72.20, -72.15, 42.50, 42.55) |>
      terra::vect(crs = crs("epsg:4326"))
    detail_xlim <- c(ext(detail_area)$xmin, ext(detail_area)$xmax)
    detail_ylim <- c(ext(detail_area)$ymin, ext(detail_area)$ymax)
    
    detail_area_web <- detail_area |>
      terra::project(crs("epsg:3857")) |> # use webmercator
      st_as_sf()
  
    maptiles::get_tiles(
      detail_area_web,
      provider = "OpenTopoMap",
      zoom = 13,
      crop =TRUE
    )
  }
)
