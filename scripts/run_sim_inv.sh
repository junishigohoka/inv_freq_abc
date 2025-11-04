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
#SBATCH --time=00:05:00
#  maximum requested memory
#SBATCH --mem=12G
#  write std out and std error to these files
#SBATCH --error=/home/ishigohoka/stdout/slim_inv%J.err
#SBATCH --output=/home/ishigohoka/stdout/slim_inv%J.out
#  send a mail for job start, end, fail, etc.
#SBATCH --mail-type=NONE
#SBATCH --mail-user=ishigohoka@evolbio.mpg.de
#  which partition?
#  there are global,testing,highmem,standard,fast
#SBATCH --partition=testing

#  add your code here:

model=$1
scenario=$2
rep=$3
outdir=$4

random=`shuf -i 0-10000000 -n 1`


awk -v seed=$random -v nsims=100 -v prefix=${model}_${scenario}_${rep} -f scripts/${model}_${scenario}_pars.awk > $outdir/${model}_${scenario}_${rep}_log.txt


if [ $model == "sim_inv_1" ];then
        while read simid seed h0 h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10
        do
                slim -s $seed \
                        -d simid=\"$simid\" \
                        -d h_0=$h0 \
                        -d h_1=$h1 \
                        -d h_2=$h2 \
                        -d h_3=$h3 \
                        -d h_4=$h4 \
                        -d h_5=$h5 \
                        -d h_6=$h6 \
                        -d h_7=$h7 \
                        -d h_8=$h8 \
                        -d h_9=$h9 \
                        -d h_10=$h10 \
                        -d s_0=$s0 \
                        -d s_1=$s1 \
                        -d s_2=$s2 \
                        -d s_3=$s3 \
                        -d s_4=$s4 \
                        -d s_5=$s5 \
                        -d s_6=$s6 \
                        -d s_7=$s7 \
                        -d s_8=$s8 \
                        -d s_9=$s9 \
                        -d s_10=$s10 \
                        scripts/$model.slim | tail -n1
                                done < $outdir/${model}_${scenario}_${rep}_log.txt > $outdir/${model}_${scenario}_${rep}_out.txt
fi

if [ $model == "sim_inv_2" ];then
while read simid seed s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 p_opt_0 p_opt_1 p_opt_2 p_opt_3 p_opt_4 p_opt_5 p_opt_6 p_opt_7 p_opt_8 p_opt_9 p_opt_10
do
        slim -s $seed \
             -d simid=\"$simid\" \
             -d h_0=0.5 \
             -d h_1=0.5 \
             -d h_2=0.5 \
             -d h_3=0.5 \
             -d h_4=0.5 \
             -d h_5=0.5 \
             -d h_6=0.5 \
             -d h_7=0.5 \
             -d h_8=0.5 \
             -d h_9=0.5 \
             -d h_10=0.5 \
             -d s_0=$s0 \
             -d s_1=$s1 \
             -d s_2=$s2 \
             -d s_3=$s3 \
             -d s_4=$s4 \
             -d s_5=$s5 \
             -d s_6=$s6 \
             -d s_7=$s7 \
             -d s_8=$s8 \
             -d s_9=$s9 \
             -d s_10=$s10 \
             -d p_opt_0=$p_opt_0 \
             -d p_opt_1=$p_opt_1 \
             -d p_opt_2=$p_opt_2 \
             -d p_opt_3=$p_opt_3 \
             -d p_opt_4=$p_opt_4 \
             -d p_opt_5=$p_opt_5 \
             -d p_opt_6=$p_opt_6 \
             -d p_opt_7=$p_opt_7 \
             -d p_opt_8=$p_opt_8 \
             -d p_opt_9=$p_opt_9 \
             -d p_opt_10=$p_opt_10 \
             scripts/$model.slim | tail -n 1
done < $outdir/${model}_${scenario}_${rep}_log.txt > $outdir/${model}_${scenario}_${rep}_out.txt
fi

