library(data.table)
library(dplyr)
library(BuenColors)

sn_atac <- fread("../data/atac_pbmc_5k_nextgem_singlecell.csv") %>%
  filter(is__cell_barcode > 0)
mt_atac <- fread("../data/PBMC_NBT_channel01_hg38_v20-mtMask.singlecell.csv") %>%
  filter(is__cell_barcode > 0)

sn_atac$what <- "SN"
mt_atac$what <- "xMT"


mean(mt_atac$mitochondrial > 1200) * 100
mean(sn_atac$mitochondrial > 1200) *100

p1 <- ggplot(rbind(sn_atac, mt_atac), aes(x = mitochondrial + 1))+
  geom_histogram(bins = 50, fill = "lightgrey", color = "black") + scale_x_log10() + 
  facet_wrap(~what) +
  labs(x = "# mtDNA fragments (log10 scaled)", y = "count") +
  pretty_plot(fontsize = 8) +
  scale_y_continuous(expand = c(0,0)) +
  geom_vline(xintercept = 1000, color = "firebrick", linetype = 2)
cowplot::ggsave2(p1, file = "../plots/mito_histo.pdf", width = 3, height = 1.4)

1200*140/16569
