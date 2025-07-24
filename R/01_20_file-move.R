  # Moves files to the specified directory
  # 01_20_file-move.R
files <- c("hoge.txt", "fuga.txt", "piyo.txt")
files
result <- file_move(files, new_path = "abc")
result

