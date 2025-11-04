#!/bin/bash



model=$1
scenario=$2
rep=$3
outdir=$4


awk -v seed=$random -v nsims=10 -v prefix=${model}_${scenario}_${rep} -f ${model}_${scenario}_pars.awk > $outdir/${model}_${scenario}_${rep}_log.txt




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
             $model.slim | tail -n 1
done < $outdir/${model}_${scenario}_${rep}_log.txt > $outdir/${model}_${scenario}_${rep}_out.txt



