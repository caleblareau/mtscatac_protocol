library(dplyr)
library(data.table)
library(BuenColors)
library(RcppRoll)
library(Matrix)
library(SummarizedExperiment)

# Theme to remove any of the other plot riff raff
xxtheme <-   theme(
  axis.line = element_blank(),
  axis.ticks.y = element_blank(),   
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.background = element_blank(),
  panel.border = element_blank(),
  panel.margin = unit(c(0, 0, 0, 0), "cm"),
  plot.margin = unit(c(-0.35, -0.35, -0.35, -0.35), "cm")) 

cov_df <- fread("../data/compare2_coverage_position.tsv")
cov_new <- cov_df[[1]]
cov_original <- cov_df[[2]]
mean(cov_original)
mean(cov_new)

# Gentle smooth of just 5 bp for plot aesthetics
smooth <- 5
data.frame(
  pos = roll_mean(1:length(cov_new), smooth),
  new = roll_mean(cov_new, smooth),  
  original = roll_mean(cov_original, smooth)
) -> df

mdf <- reshape2::melt(df, id.var = "pos")

# Visualize the rolled means
P1 <- ggplot(mdf, aes(x = pos, y = value, color = variable)) + 
  geom_line() +  expand_limits(y = c(-5, 4)) +
  pretty_plot(fontsize = 8)  + scale_color_manual(values = c("firebrick", "dodgerblue4")) +
  labs(x = "", y = "log10 Coverage") + scale_y_log10() + geom_hline(yintercept = 30, linetype = 2) + pretty_plot(fontsize = 6) +
  theme(legend.position = "none") + L_border() 
P1
cowplot::ggsave2(P1, file = "../plots/rollMean_coverage-linear.pdf", width = 3, height = 1.3)
