#!/bin/bash
#SBATCH --mem=10G
#SBATCH --job-name=plotprecast
#SBATCH --output=./libd_precast/out_files/%x_%A_%a.out
#SBATCH --error=./libd_precast/out_files/%x_%A_%a.err

date
input=$(head -n $SLURM_ARRAY_TASK_ID ./libd_precast/code/precast_seurat_file-names.txt | tail -n 1)
echo $input
module load conda_R/devel
module list
Rscript /users/jthompso/libd_precast/code/plotprecast.r $input
echo "Finished!"
date
