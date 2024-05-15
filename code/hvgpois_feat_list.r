library(SpatialExperiment)
library(scran)
library(here)
set.seed(123)

spe <- readRDS(here("spe_libd-full_qc-filt.rds"))
rownames(colData(spe)) <- paste(spe$sample_id, rownames(colData(spe)), sep="_")
colnames(counts(spe)) <- rownames(colData(spe))
colData(spe)$col <- spe$array_col
colData(spe)$row <- spe$array_row

decp <- modelGeneVarByPoisson(spe, block=spe$subject)
hvgp <- getTopHVGs(decp, n=2000)
saveRDS(hvgp, here("libd_precast","out_obj","libd-all_hvgpois-batch_2k-features.rds"))
