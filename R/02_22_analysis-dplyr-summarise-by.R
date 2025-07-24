  # Calculate means using .by
  # 02_22_analysis-dplyr-summarise-by.R
dplyr::summarise(answer_mutated, m_years = mean(years), 
                 m_satisfy = mean(satisfy), .by = area)

