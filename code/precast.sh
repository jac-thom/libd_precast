#!/bin/bash
#SBATCH --mem=80G
#SBATCH --ntasks=12
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jthom338@jh.edu
#SBATCH --job-name=precast
#SBATCH --error=./libd_precast/out_files/%x_%j.err
#SBATCH --output=./libd_precast/out_files/%x_%j.out

echo "**** JHPCE info ****"
echo "User: ${USER}"
echo "Job id: ${SLURM_JOB_ID}"
echo "Job name: ${SLURM_JOB_NAME}"
echo "Node(s): ${SLURM_NODELIST}"
echo "n Tasks: ${SLURM_NTASKS}"

date
module load conda_R/devel
module list
Rscript /users/jthompso/libd_precast/code/precast.r

echo "Finished!"
date
