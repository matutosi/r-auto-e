  # function in error when 2
  # 02_49_analysis-purrr-possibly-prep.R
error_if_two <- function(x){
  if(x == 2){
    stop("Error")
  }else{
    return(x)
  }
}

