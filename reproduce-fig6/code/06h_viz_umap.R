library(data.table)
library(dplyr)
library(BuenColors)

ref_map <- fread("../data/PBMC_NBT_channel01_hg38_v20-refmapped.csv.gz")

p1 <- ggplot(ref_map, aes(x = refUMAP_1, y = refUMAP_2, color = predicted.celltype.l1)) +
  geom_point(size = 0.2) +
  scale_color_manual(values = jdb_palette("corona")) +
  theme_void() + labs(color = "")
#cowplot::ggsave2(p1, file = "../plots/cellstate_umap.pdf", width = 3, height = 2)

# import heteroplasmy
hetmap <- fread("../data/PBMC_NBT_channel01_hg38_v20-mtMask.cell_heteroplasmic_df.tsv.gz")

merge(ref_map, 
      hetmap, 
      by.x = "cb", by.y = "V1") -> merge_df

p1 <- ggplot(merge_df %>% arrange(`7389T>C`), aes(x = refUMAP_1, y = refUMAP_2, color = `7389T>C`)) +
  geom_point(size = 0.5) + theme_void() +
  scale_color_gradientn(colors = c("lightgrey", "firebrick")) +
  theme(legend.position = "none")
cowplot::ggsave2(p1, file = "../plots/variant_umap.png", width = 3, height = 3, dpi = 500)

sort(colSums(data.matrix(data.frame(hetmap[,-1]))> 0.9) )

     