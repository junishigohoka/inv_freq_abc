#!/bin/bash
#
#  example submit script for a serial job
#  submit by  sbatch serial-job.sh
#
#  specify the job name
#SBATCH --job-name=pyslim
#  how many cpus are requested
#SBATCH --ntasks=1
#  run on one node, importand if you have more than 1 ntasks
#SBATCH --nodes=1
#  maximum walltime, here 10min
#SBATCH --time=48:00:00
#  maximum requested memory
#SBATCH --mem=50G
#  write std out and std error to these files
#SBATCH --error=/home/ishigohoka/stdout/pyslim%J.err
#SBATCH --output=/home/ishigohoka/stdout/pyslim%J.out
#  send a mail for job start, end, fail, etc.
#SBATCH --mail-type=NONE
#SBATCH --mail-user=ishigohoka@evolbio.mpg.de
#  which partition?
#  there are global,testing,highmem,standard,fast
#SBATCH --partition=standard

#  add your code here:


in=$1
out=$2
scale=$3


module load python/3.7.1



python scripts/model_2_1_2_abc_slim_pyslim.py -i $in -o $out --scale $scale

