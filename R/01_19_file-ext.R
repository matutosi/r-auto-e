  # Extracts only the extension and file name
  # 01_19_file-ext.R
path_ext(md_files)
path_ext_remove(md_files)
  # Include subdirectories
all_files <- dir_ls(type = "file", recurse = TRUE)
path_ext(all_files)
path_ext_remove(all_files)

