  # Generate dummy files with different modification times
  # 01_29_file-rename-info-prep.R
olds <- paste0(letters[1:10], ".xlsx")
for(old in sample(olds)){
  file_create(old)
  Sys.sleep(60)
}
shell.exec(path_wd()) # Open working directory (Windows only)

