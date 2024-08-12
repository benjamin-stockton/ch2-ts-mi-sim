#!/bin/bash 
#SBATCH --partition=general
#SBATCH --constraint='epyc128'
#SBATCH --cpus-per-task=125
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mail-type=END
#SBATCH --mail-user=benjamin.stockton@uconn.edu
cd .. 

source /etc/profile.d/modules.sh
module purge
module load r/4.3.2

echo "Running sim_scripts/mar-ts-mi-sim_setting-2.R" 
time Rscript "sim_scripts/mar-ts-mi-sim_setting-2.R"

echo "Done!"
