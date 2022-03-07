library(data.table)
library(Matrix)
library(dplyr)
library(SummarizedExperiment)

# Import mgatk object
SE <- readRDS("mtscatac.rds")
ref_allele <- toupper(as.character(rowRanges(SE)$refAllele))

# Split the heteroplasmy into forward and reverse for making these comparison plots
cov_fw <- assays(SE)[[paste0("A_counts_fw")]] + assays(SE)[[paste0("C_counts_fw")]] + assays(SE)[[paste0("G_counts_fw")]]+ assays(SE)[[paste0("T_counts_fw")]]+ 0.001
getMutMatrix_fw  <- function(letter){
  mat <- (assays(SE)[[paste0(letter, "_counts_fw")]]) / cov_fw
  rownames(mat) <- paste0(as.character(1:dim(mat)[1]), toupper(ref_allele), ">", letter)
  ref_letter <- toupper(ref_allele)
  return(mat[ref_letter != letter & ref_letter != "N",])
}

cov_rev <- assays(SE)[[paste0("A_counts_rev")]] + assays(SE)[[paste0("C_counts_rev")]] + assays(SE)[[paste0("G_counts_rev")]]+ assays(SE)[[paste0("T_counts_rev")]] + 0.001
getMutMatrix_rev  <- function(letter){
  mat <- (assays(SE)[[paste0(letter, "_counts_rev")]]) / cov_rev
  rownames(mat) <- paste0(as.character(1:dim(mat)[1]), toupper(ref_allele), ">", letter)
  ref_letter <- toupper(ref_allele)
  return(mat[ref_letter != letter & ref_letter != "N",])
}

# Get heteroplasmy matrix for each direction
cells_forward <- rbind(getMutMatrix_fw("A"), getMutMatrix_fw("C"), getMutMatrix_fw("G"), getMutMatrix_fw("T"))
cells_reverse <- rbind(getMutMatrix_rev("A"), getMutMatrix_rev("C"), getMutMatrix_rev("G"), getMutMatrix_rev("T"))

# read in meta data summary statistics
dt <- fread("mtscatac_protocol/reproduce-fig6/data//PBMC_NBT_channel01_hg38_v20-mtMask.variant_stats.tsv.gz") %>% data.frame()
dt %>% filter(mean < 0.9) %>% arrange(desc(mean)) %>%
  filter(strand_correlation > 0.65)

# aggregate specific mutations based on the above analyis
vars <- c("13677C>G", "7389T>C")
df <- cbind(
  reshape2::melt(data.matrix(cells_forward[vars,])) %>% setNames(c("mut", "barcode", "forward")),
  reshape2::melt(data.matrix(cells_reverse[vars,])) %>% setNames(c("mutation", "barcode2", "reverse"))
)

# Visualize
library(BuenColors)
p1 <- ggplot(df, aes(x = (forward), y = (reverse))) +
  geom_point(size = 0.01) + labs(x = "Forward heteroplasmy", y = "Reverse heteroplasmy") +
  facet_wrap(~mutation) + pretty_plot(fontsize = 8) + scale_x_continuous(limits = c(0,1)) + scale_y_continuous(limits = c(0,1))
p1
cowplot::ggsave2(p1, file = "plot_twoStrands_compare_variants.pdf", width = 2, height = 1)
