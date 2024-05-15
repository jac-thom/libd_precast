library(SpatialExperiment)
library(scry)
library(dplyr)
library(here)
set.seed(123)

spe <- readRDS(here("spe_libd-full_qc-filt.rds"))
rownames(colData(spe)) <- paste(spe$sample_id, rownames(colData(spe)), sep="_")
colnames(counts(spe)) <- rownames(colData(spe))
colData(spe)$col <- spe$array_col
colData(spe)$row <- spe$array_row

spe <- devianceFeatureSelection(spe, fam="binomial", batch=as.factor(spe$subject))
top.dev.batch = rownames(arrange(as.data.frame(rowData(spe)), desc(binomial_deviance)))[1:2000]
saveRDS(top.dev.batch, here("libd_precast","out_obj","libd-all_bindev-batch_2k-features.rds"))
