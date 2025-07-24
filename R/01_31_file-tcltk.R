  # Selecting file or directory with mouse
  # 01_31_file-tcltk.R
selected_file <- tcltk::tk_choose.files() # To select a file
  # Mouse operation here
selected_file
selected_dir <- tcltk::tk_choose.dir() # To select a directory
  # Mouse operation here
selected_dir
setwd(selected_dir)
getwd()

