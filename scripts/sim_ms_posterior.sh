#!/bin/bash
#
#  example submit script for a serial job
#  submit by  sbatch serial-job.sh
#
#  specify the job name
#SBATCH --job-name=ms
#  how many cpus are requested
#SBATCH --ntasks=1
#  run on one node, importand if you have more than 1 ntasks
#SBATCH --nodes=1
#  maximum walltime, here 10min
#SBATCH --time=24:00:00
#  maximum requested memory
#SBATCH --mem=32G
#  write std out and std error to these files
#SBATCH --error=/home/ishigohoka/stdout/ms_posterior%J.err
#SBATCH --output=/home/ishigohoka/stdout/ms_posterior%J.out
#  send a mail for job start, end, fail, etc.
#SBATCH --mail-type=NONE
#SBATCH --mail-user=ishigohoka@evolbio.mpg.de
#  which partition?
#  there are global,testing,highmem,standard,fast
#SBATCH --partition=standard

#  add your code here:



module load R/4.2.0

model=model_2_1_2


n=`awk 'NR>1{c++}END{print c}' output/demography/abc/model_2_1_2_posterior.txt`


seq $n | while read j
do
        random=`shuf -i 1-1000000000 -n 1`
        command=`Rscript scripts/write_config_model_2_1_2_posterior.R 1  | awk -v seed=$random -f scripts/write_ms_model_2.awk`
        $command | awk -v simid=$j -f scripts/ms2stats.awk - list/pop_nhaps.txt 
        echo $random >> output/demography/post_ms_slim/${model}_posterior_ms_seed.txt
done > output/demography/post_ms_slim/${model}_posterior_ms_out.txt


