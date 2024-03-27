#!/bin/bash
#
#  example submit script for a serial job
#  submit by  sbatch serial-job.sh
#
#  specify the job name
#SBATCH --job-name=abcrf
#  how many cpus are requested
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#  run on one node, importand if you have more than 1 ntasks
#SBATCH --nodes=1
#  maximum walltime, here 10min
#SBATCH --time=120:00:00
#  maximum requested memory
#SBATCH --mem=1000G
#  write std out and std error to these files
#SBATCH --error=/home/ishigohoka/stdout/abcrf%J.err
#SBATCH --output=/home/ishigohoka/stdout/abcrf%J.out
#  send a mail for job start, end, fail, etc.
#SBATCH --mail-type=NONE
#SBATCH --mail-user=ishigohoka@evolbio.mpg.de
#  which partition?
#  there are global,testing,highmem,standard,fast
#SBATCH --partition=highmem

#  add your code here:

module load R/4.2.0
Rscript scripts/abcrf_modsel.R


