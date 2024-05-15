library(Seurat)
library(PRECAST)
library(SpatialExperiment)
library(scuttle)
library(ggplot2)
library(parallel)
library(here)
set.seed(123)

feature.list = readRDS(here("libd_precast","out_obj","libd-all_feature-list.rds"))
spe <- readRDS(here("spe_libd-full_qc-filt.rds"))
spe <- computeLibraryFactors(spe)
spe <- logNormCounts(spe)
rownames(colData(spe)) <- paste(spe$sample_id, rownames(colData(spe)), sep="_")
colnames(counts(spe)) <- rownames(colData(spe))
colData(spe)$col <- spe$array_col
colData(spe)$row <- spe$array_row

sample.list = unique(spe$sample_id)
names(sample.list) = sample.list
sample.list = lapply(sample.list, function(x) colData(spe)$sample_id==x)
srt.sets = mclapply(sample.list, function(x) {
  count <- counts(spe)[,x]
  a1 <- CreateAssayObject(count, assay = "RNA", min.features = 0, min.cells = 0)
  CreateSeuratObject(a1, meta.data = as.data.frame(colData(spe)[x,]))
}, mc.cores=12)
saveRDS(srt.sets, here("libd_precast","out_obj","srt_libd-full_qc-filt_all-samples.rda"))
mclapply(seq_along(feature.list), function(x) {
	preobj = CreatePRECASTObject(seuList = srt.sets, customGenelist=feature.list[[x]], premin.spots=0, premin.features=0, postmin.spots=0, postmin.features=0)
	preobj@seulist
	PRECASTObj <- AddAdjList(preobj, platform = "Visium")
	PRECASTObj <- AddParSetting(PRECASTObj, coreNum = 12, Sigma_equal=TRUE, maxIter = 30, verbose = TRUE)
	PRECASTObj <- PRECAST(PRECASTObj, K = 7)
	PRECASTObj <- SelectModel(PRECASTObj, criteria="MBIC")
	seuInt = IntegrateSpaData(PRECASTObj, species = "Human")
	saveRDS(seuInt, here("libd_precast","out_obj",paste0("srt_libd-full_qc-filt_all-samples_precast-",names(feature.list)[x],".rda")))
}, mc.cores=3)
