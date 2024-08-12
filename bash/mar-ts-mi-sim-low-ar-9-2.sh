#!/bin/bash 
#SBATCH --partition=lo-core
#SBATCH --constraint='epyc128'
#SBATCH --cpus-per-task=60
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=benjamin.stockton@uconn.edu
cd .. 

echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-9-2.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-9-2.R"

echo "Done!"
