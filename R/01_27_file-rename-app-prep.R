  # Generate alphabetical dummy files
  # 01_27_file-rename-app-prep.R
paste0(letters[1:10], ".pdf") |>
  file_create()
shell.exec(path_wd()) # Open working directory (Windows only)

