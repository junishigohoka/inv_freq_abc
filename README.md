# Analysis of historical change in selection on balanced inversion in blackcap


# Question

In genealogy-based analysis of historical population structure, I discovered that island populations represent multiple independent colonisation events.
In the local variation paper, I found putative inversion segregating in most blackcap populations.
This inversion is under long-term balancing selection.
The frequency of the inversion is stable across the continental popualtions, and it is always lower in island populations, which cannot be explained by drift.
Despite multiple colonisation events

# Overview

1. Demography inference using ABC
  1. Simulation of demography models with `ms`
  2. Model selection with `abc`
  3. Parameter inference with `abc`
2. 
  1. Validation of `SLiM` simulation
  2. Simulation of selection models in `SLiM`
  3. Model selection with `abc`
  4. Paramter inference with `abc`


# Demography simulation with `ms`


+ Georgia: One split vs two splits
+ cont_resident: constant vs decrease
+ gene flow: nomig, mig

Model 1: All 10 populations split at the same time

Model 1-1-1: one split, constant, nomig
Model 1-1-2: one split, constant, mig
Model 1-2-1: one split, decrease, nomig
Model 1-2-2: one split, decrease, mig
Model 2-1-1: two splits, constant, nomig
Model 2-1-2: two splits, constant, mig
Model 2-2-1: two splits, decrease, nomig
Model 2-2-2: two splits, decrease, mig



```bash

for model in model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2
do
        echo $model
        time for i in {1..100}
        do
                random=$RANDOM
                command=`awk -v simid=$i -v seed=$random -v logfile=$model.log -f scripts/write_config_$model.awk list/pop_nhaps.txt | awk -v seed=$random -f scripts/write_ms_model1.awk`
                $command | awk -v simid=$i -f scripts/ms2stats.awk - list/pop_nhaps.txt 
        done > $model.out
done


for model in model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
do
        echo $model
        time for i in {1..100}
        do
                random=$RANDOM
                command=`awk -v simid=$i -v seed=$random -v logfile=$model.log -f scripts/write_config_$model.awk list/pop_nhaps.txt | awk -v seed=$random -f scripts/write_ms_model2.awk`
                $command | awk -v simid=$i -f scripts/ms2stats.awk - list/pop_nhaps.txt 
        done > $model.out
done


```





# Selection




