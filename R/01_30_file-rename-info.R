  # Example of renaming files sequentially numbered by update time
  # 01_30_file-rename-info.R
files <- 
  dir_info(regexp = "\\.xlsx$") |>
  dplyr::arrange(modification_time) |> # arrange by modification_time
  `$`(_, "path")  # same as _$path
files
no <- 
  1:length(files) |>  # same as seq_along(files)
  stringr::str_pad(width = 3, side = "left", pad = "0")
new_files <- stringr::str_c(no, "_", files)
new_files
file_move(files, new_files)

