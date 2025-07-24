  # Filter files using `dir_info()` and `stringr::str_detect()`
  # 01_17_file-info-filter.R

dir_info() |>
  dplyr::filter(size > 10^3) |> # size > 1000
  dplyr::filter(stringr::str_detect(path, "[A-G]")) # contains A-G

