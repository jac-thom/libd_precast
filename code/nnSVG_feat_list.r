library(SpatialExperiment)
library(nnSVG)
library(here)
set.seed(123)

spe <- readRDS(here("spe_libd-full_qc-filt.rds"))
spe <- filter_genes(spe, filter_genes_ncounts = 3, filter_genes_pcspots = .5,
        filter_mito=F)
spe_nnSVG <- nnSVG(spe, n_threads=12)
svg = rowData(spe_nnSVG)[rowData(spe_nnSVG)$padj <= 0.05,]
saveRDS(svg, here("libd_precast","out_obj","libd-all_nnSVG_p-05-features-df.rds"))
