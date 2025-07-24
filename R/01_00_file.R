  # Installing and calling fs package
  # 01_01_file-install.R
install.packages("fs")
library(fs)

  # Function list in fs package
  # 01_02_file-list.R
ls("package:fs") |> stringr::str_subset("^dir")
ls("package:fs") |> stringr::str_subset("^file") |> head()
ls("package:fs") |> stringr::str_subset("^path") |> head()

  # Get working directory
  # 01_03_file-getwd.R
 # Display varies by OS, encironment, etc. 
 # For Windows, the user name is displayed in USERNAME. 
path_wd()
getwd() # you can get the same thing as a string

  # Set fs package directory to working directory
  # 01_04_file-setwd-pkg.R
wd <- path_package("fs")
wd
setwd(wd)

  # Get path of temporary directory
  # 01_05_file-path-temp.R
path_temp()
path_temp("hoge.txt")

  # Get name for temporary file
  # 01_06_file-file-temp.R
file_temp()
file_temp(pattern = "example_", ext = "txt")

  # Generate working files and directories
  # 01_07_file-create.R
file_create(c("hoge.txt", "fuga.txt", "piyo.txt"))
dir_create("abc")

  # : Get file and directory list
  # 01_08_file-ls.R
dir_ls()
dir_ls(recurse = TRUE) # Display lower directories with recurse = TRUE

  # Get list with `type` argument
  # 01_09_file-ls-type.R
dir_ls(type = "file")      # file only
dir_ls(type = "directory") # directory only

  # Get directory list with path
  # 01_10_file-ls-stringr.R
dir_ls(path = path_package("stringr"))

  # Get list of files (full paths) in working directory
  # 01_11_file-ls-fullpath.R
dir_ls(path = path_wd(), type = "file")

  # Get list using regular expression
  # 01_12_file-regexp.R
dir_ls(type = "file", recurse = TRUE, regexp = "(doc|html)")

  # Tree view of directories
  # 01_13_file-ls-tree.R
dirs <- dir_tree()
dirs
dir_tree(type = "directory") # directory only

  # Tree view of directories with `recurse`
  # 01_14_file-ls-tree-recurse.R
dir_tree(recurse = 0) # do not display lower-level directories
dir_tree(recurse = 1) # display down to one lower directory

  # Get file or directory existence
  # 01_15_file-exests.R
file_exists("DESCRIPTION")
file_exists("DESCRIPTIONS")
dir_exists("doc")
dir_exists("docs")

  # Filter files using `dir_info()` and `stringr::str_detect()`
  # 01_17_file-info-filter.R

dir_info() |>
  dplyr::filter(size > 10^3) |> # size > 1000
  dplyr::filter(stringr::str_detect(path, "[A-G]")) # contains A-G

  # Set Extension
  # 01_18_file-ext-set.R
md_files <- dir_ls(type = "file", regexp = "\\.md$")
md_files
txt_file <- path_ext_set(md_files, "txt")
txt_file

  # Extracts only the extension and file name
  # 01_19_file-ext.R
path_ext(md_files)
path_ext_remove(md_files)
  # Include subdirectories
all_files <- dir_ls(type = "file", recurse = TRUE)
path_ext(all_files)
path_ext_remove(all_files)

  # Moves files to the specified directory
  # 01_20_file-move.R
files <- c("hoge.txt", "fuga.txt", "piyo.txt")
files
result <- file_move(files, new_path = "abc")
result

  # Move file to working directory
  # 01_21_file-move-again.R
result <- file_move(result, new_path = ".")
result


  # Copying files in a directory
  # 01_22_file-copy.R
copy_files <- stringr::str_c("copy_", files) # name of the copied files
(file_copy(files, copy_files))               # Display the result with ()

  # Copying a file to the specified directory
  # 01_23_file-copy-abc.R
(result <- file_copy(files, "abc")) # display result with () 

  # Error in copying file
  # 01_24_file-copy-error.R
file_copy(files, "abc")  # Unable to overwrite error

  # Delete File
  # 01_25_file-delete.R
(file_delete(copy_files))
(file_delete(result)) # result is specified in code 1.21

  # Rename files
  # 01_26_file-rename.R
(files <- dir_ls(regexp = "\\.txt$"))            # Files to be renamed
(new_path <- c("foo.txt", "bar.txt", "baz.txt")) # modified file name
(file_move(files, new_path))

  # Generate alphabetical dummy files
  # 01_27_file-rename-app-prep.R
paste0(letters[1:10], ".pdf") |>
  file_create()
shell.exec(path_wd()) # Open working directory (Windows only)

  # Example of multiple file renames
  # 01_28_file-rename-files.R
old <- dir_ls(regexp = "\\.pdf$")
len <- length(old)
new <- 
  paste0(stringr::str_pad(1:len, width = 2, side = "left", pad = "0"), ".pdf")
file_move(old, new)

  # Generate dummy files with different modification times
  # 01_29_file-rename-info-prep.R
olds <- paste0(letters[1:10], ".xlsx")
for(old in sample(olds)){
  file_create(old)
  Sys.sleep(60)
}
shell.exec(path_wd()) # Open working directory (Windows only)

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

  # A function to sort files by extension
  # 01_32_file-sort-fun.R
sort_files <- function(dir, show_tree = FALSE, ...){
  files <- fs::dir_ls(dir, type = "file", ...)         # list of files
  moves_to <- fs::path_ext(files)                      # destination
  dup <- fs::path_file(files) |> duplicated() |> any() # duplicates
  if(dup){                                             # when duplicated
    stop("Some file is duplicated")
  }
  sub_dirs <- unique(moves_to)                         # list of directories
  exists <- fs::dir_exists(fs::path(dir, sub_dirs))
  if(sum(exists) > 0){                                 # when directories exist
    stop(fs::path(dir, sub_dirs)[exists], " exists")
  }
  purrr::walk(sub_dirs, fs::dir_create, path = dir)    # create directories
  res <- fs::file_move(files, fs::path(dir, moves_to)) # move files
  if(show_tree){
    fs::dir_tree(dir)
  }
  return(res)
}

  # Sort files by extension (pseudo code)
  # 01_33_file-sort.R
sort_files("dir", show_tree = TRUE)

  # Delete working files and directories
  # 01_34_file-delete-temp.R
txts <- paste0(c("foo", "bar", "baz"), ".txt")
xlsxs <- dir_ls(regexp = "^\\d{3}_[a-j]\\.xlsx")
pdfs <- dir_ls(regexp = "^\\d{2}\\.pdf")
file_delete(c(txts, xlsxs, pdfs))
dir_delete("abc")

