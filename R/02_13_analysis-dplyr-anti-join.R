  # Extracting missing data
  # 02_13_analysis-dplyr-anti-join.R
lost <- dplyr::filter(answer_joined, apps != "-")     # drop when apps == "-"
print(answer_joined, n = 3)                           # all data
print(lost, n = 3)                                    # apps != "-"
dplyr::anti_join(answer_joined, lost) |> print(n = 3) # apps == "-"

