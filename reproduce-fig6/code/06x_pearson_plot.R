library(dplyr)
library(data.table)
library(BuenColors)

dt <- fread("../data/PBMC_NBT_channel01_hg38_v20-mtMask.variant_stats.tsv.gz") %>% data.frame()

p1 <- ggplot(dt %>%  filter(n_cells_conf_detected >= 3 ), aes(x = strand_correlation, y = log10(vmr), color = log10(vmr) > -2 & strand_correlation > 0.65)) +
  geom_point(size = 0.4) + scale_color_manual(values = c("black", "firebrick")) +
  labs(color = "HQ", x = "Strand concordance", y = "log VMR") +
  pretty_plot(fontsize = 7) + L_border() +
  theme(legend.position = "bottom") + 
  geom_vline(xintercept = 0.65, linetype = 2) +
  geom_hline(yintercept = -2, linetype = 2) + theme(legend.position = "none")
p1
cowplot::ggsave2(p1, file = "../plots/var_call_ndetect.pdf", width = 1.5, height = 1.5)
