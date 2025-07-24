  # Copying files in a directory
  # 01_22_file-copy.R
copy_files <- stringr::str_c("copy_", files) # name of the copied files
(file_copy(files, copy_files))               # Display the result with ()

