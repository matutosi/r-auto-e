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

