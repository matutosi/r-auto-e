  # splitting a scatterplot using for and subset()
  # 02_34_analysis-ggplot-facet-for.R
par(mfcol = c(3, 3))
  par(mar = rep(1.5, 4))
  par(oma = rep(1.5, 4))
for(s in unique(sales_joined$shop)){
  sales_sub <- subset(sales_joined, shop == s)
  plot(factor(sales_sub$item), sales_sub$count)
}

