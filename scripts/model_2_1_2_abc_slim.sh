#!/bin/bash
#
#  example submit script for a serial job
#  submit by  sbatch serial-job.sh
#
#  specify the job name
#SBATCH --job-name=slim
#  how many cpus are requested
#SBATCH --ntasks=1
#  run on one node, importand if you have more than 1 ntasks
#SBATCH --nodes=1
#  maximum walltime, here 10min
#SBATCH --time=06:00:00
#  maximum requested memory
#SBATCH --mem=100G
#  write std out and std error to these files
#SBATCH --error=/home/ishigohoka/stdout/slim%J.err
#SBATCH --output=/home/ishigohoka/stdout/slim%J.out
#  send a mail for job start, end, fail, etc.
#SBATCH --mail-type=NONE
#SBATCH --mail-user=ishigohoka@evolbio.mpg.de
#  which partition?
#  there are global,testing,highmem,standard,fast
#SBATCH --partition=standard

#  add your code here:

scale=$1
rep=$2
T0=$3
T1=$4



sed "s/t0/$T0/g;s/t1/$T1/g" scripts/model_2_1_2_abc.slim | slim -d scale=$scale -d rep=$rep 


