  # A function to read all sheets in Excel
  # 02_03_analysis-read-all-sheets-fun.R
read_all_sheets <- function(path, add_sheet_name = TRUE){
  sheets <- openxlsx::getSheetNames(path)  # list of sheet names
  xlsx <- 
    sheets |>
    purrr::map(\(x){                       # for each sheet
      openxlsx::read.xlsx(path, sheet = x) # read data
    }) |>
    purrr::map(tibble::tibble)             # convert to tibble
  names(xlsx) <- sheets                    # sheet name
  if(add_sheet_name){                      # add sheet name to tibble or not
    xlsx <- purrr::map2(xlsx, sheets,
      \(.x, .y){
        dplyr::mutate(.x, sheet = .y)      # add column for sheet name
      }
    )
  }
  return(xlsx)
}
  # A function to count multiple answers
  # 02_26_analysis-dplyr-count-multi-ans-fun.R
count_multi <- function(df, col, delim = "[^[:alnum:]]+", group_add = TRUE){
  df |>
    tidyr::separate_longer_delim(tidyselect::all_of(col),    # split vertically
                                 delim = delim) |> 
    dplyr::filter({{ col }} != "") |>                            # remove empty
    dplyr::filter(!is.na({{ col }})) |>                          # remove NA
    dplyr::group_by(dplyr::pick({{ col }}), .add = group_add) |> # grouping
    dplyr::tally() |>                                            # cout number
    dplyr::filter({{ col }} != "")                               # remove empty
}
  # function in error when 2
  # 02_49_analysis-purrr-possibly-prep.R
error_if_two <- function(x){
  if(x == 2){
    stop("Error")
  }else{
    return(x)
  }
}
  # A function to add new stuff
  # 02_52_analysis-purrr-paste-if-new-fun.R
paste_if_new <- function(x, y){
  pattern <- paste0("(^|;)+", y, "(;|$)+")
  if(stringr::str_detect(x, pattern)){
    x
  }else{
    paste0(x, ";", y)
  }
}
  print(n = 3)

