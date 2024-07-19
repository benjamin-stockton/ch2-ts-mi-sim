#!/bin/bash 
#SBATCH --partition=general
#SBATCH --constraint='epyc128'
#SBATCH --cpus-per-task=125
#SBATCH --ntasks=1
#SBATCH --nnodes=1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=benjamin.stockton@uconn.edu
cd .. 

echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-1.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-1.R"
echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-2.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-2.R"
echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-3.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-3.R"
echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-4.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-4.R"
echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-5.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-5.R"
echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-6.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-6.R"
echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-7.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-7.R"
echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-8.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-8.R"
echo "Running sim_scripts/mar-ts-mi-low-ar-sim_setting-9.R" 
time Rscript "sim_scripts/mar-ts-mi-low-ar-sim_setting-9.R"

echo "Done!"
