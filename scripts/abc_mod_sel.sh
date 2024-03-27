#!/bin/bash
#
#  example submit script for a serial job
#  submit by  sbatch serial-job.sh
#
#  specify the job name
#SBATCH --job-name=abc_modsel
#  how many cpus are requested
#SBATCH --ntasks=1
#  run on one node, importand if you have more than 1 ntasks
#SBATCH --nodes=1
#  maximum walltime, here 10min
#SBATCH --time=480:00:00
#  maximum requested memory
#SBATCH --mem=512G
#  write std out and std error to these files
#SBATCH --error=/home/ishigohoka/stdout/abc_modsel%J.err
#SBATCH --output=/home/ishigohoka/stdout/abc_modsel%J.out
#  send a mail for job start, end, fail, etc.
#SBATCH --mail-type=NONE
#SBATCH --mail-user=ishigohoka@evolbio.mpg.de
#  which partition?
#  there are global,testing,highmem,standard,fast
#SBATCH --partition=highmemnew

#  add your code here:

module load R/4.2.0

Rscript scripts/abc_dem_modsel.R

