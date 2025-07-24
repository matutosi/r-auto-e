  # Handling errors in iterative processing
  # 02_50_analysis-purrr-possibly.R
purrr::map(1:3, error_if_two)  # when left as is
error_if_two_possibly <- possibly(error_if_two, otherwise = 0) # 0 if error
purrr::map_dbl(1:3, error_if_two_possibly)

