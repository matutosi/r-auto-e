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

