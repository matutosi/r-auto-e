  # Rename files
  # 01_26_file-rename.R
(files <- dir_ls(regexp = "\\.txt$"))            # Files to be renamed
(new_path <- c("foo.txt", "bar.txt", "baz.txt")) # modified file name
(file_move(files, new_path))

