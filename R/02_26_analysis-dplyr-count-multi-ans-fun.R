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

