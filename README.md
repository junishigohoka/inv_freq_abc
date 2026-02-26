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


# ABC inference of demography parameter

## Demography simulation with `ms`


Georgia: earlier split vs same splits
cont_resident: constant vs decrease
gene flow: nomig, mig



Model 1-1-1: one split, constant, nomig
Model 1-1-2: one split, constant, mig
Model 1-2-1: one split, decrease, nomig
Model 1-2-2: one split, decrease, mig
Model 2-1-1: Geo first, constant, nomig
Model 2-1-2: Geo first, constant, mig
Model 2-1-3: Geo first, constant, more splits
Model 2-2-1: Geo first, decrease, nomig
Model 2-2-2: Geo first, decrease, mig
Model 2-2-3: Geo first, decrease, more splits

```bash

#for model in model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
for model in model_1_1_2 model_1_2_2 model_2_1_2 model_2_2_2
do
        for i in {0..99}
        do
                outdir=`printf "output/demography/ms/%s/%02d" $model $i`
                mkdir -p $outdir
                for j in {0..99}
                do
                        outprefix=`printf "%s_%02d_%02d" $model $i $j`
                        echo sbatch scripts/sim_ms.sh -m $model -o $outdir/$outprefix -p list/pop_nhaps.txt -d $PWD/scripts -n 100 -l 1000
                done
        done
done > scripts/commands.list







```

In screen

```bash

submit_sbatch.sh -i scripts/commands.list -p ms -r 40 -w 20

```





Once simulations have completed, I concatenated the output.
I noticed that some logs are missing though output file exists.
Results of such simulations are useless because there is no parameter values to associate with.
So I did concatenation only if log file exists.

```bash

#for model in model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
for model in model_1_1_2 model_1_2_2 model_2_1_2 model_2_2_2
do
        for i in {0..99}
        do
                outdir=`printf "output/demography/ms/%s/%02d" $model $i`
                for j in {0..99}
                do
                        outprefix=`printf "%s_%02d_%02d" $model $i $j`
                        if [ -f $outdir/$outprefix.log ];then
                                cat -e $outdir/$outprefix.out | grep "$" | sed 's/\$//' | awk -v n1=$i -v n2=$j -v outprefix=$outprefix 'BEGIN{n=n1*1e4 + n2*1e2}n1==0&&n2==0&&NR==1{print $0}NR>1{$1+=n;print $0}'
                        fi
                done
        done > output/demography/ms/${model}_out.txt
done  

```

I did the same for log files.
Note that log files may contain records that was not included in output (because log was written before running simulation).

```bash

#for model in model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
for model in model_1_1_2 model_1_2_2 model_2_1_2 model_2_2_2
do
        for i in {0..99}
        do
                outdir=`printf "output/demography/ms/%s/%02d" $model $i`
                for j in {0..99}
                do
                        outprefix=`printf "%s_%02d_%02d" $model $i $j`
                        if [ -f $outdir/$outprefix.log ];then
                                cat -e $outdir/$outprefix.log | grep "$" | sed 's/\$//' | awk -v n1=$i -v n2=$j -v outprefix=$outprefix 'BEGIN{n=n1*1e4 + n2*1e2}n1==0&&n2==0&&NR==1{print $0}NR>1{$1+=n;print $0}'
                        fi
                done
        done > output/demography/ms/${model}_log.txt
done  

```


I gzipped all

```bash

#for model in model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
#for model in model_1_2_1
for model in model_1_1_2 model_1_2_2 model_2_1_2 model_2_2_2
do
        gzip output/demography/ms/${model}_out.txt
        gzip output/demography/ms/${model}_log.txt
done

```





### Revision 1. Additional scenarios with different split times among 4 resident populations

Instead of T_split, I have 5 values: T_split_mac, T_split_mal, T_split_cre, T_split_cont, T_split_short.
Scripts were edited for model_2_1_3 and model_2_2_3.


For each model, I ran 1,000,000 simulations by submitting an array job of 10,000, each of which runs 100.

```bash

for model in model_2_1_3 model_2_2_3
do
        for i in {0..99}
        do
                outdir=`printf "output/demography/ms/%s/%02d" $model $i`
                mkdir -p $outdir
                for j in {0..99}
                do
                        outprefix=`printf "%s_%02d_%02d" $model $i $j`
                done
        done
done 


for model in model_2_1_3 model_2_2_3
do
    qsub scripts/sim_ms_qsub.sh -m $model -p list/pop_nhaps.txt -d $PWD/scripts -n 100 -l 1000
done



```





Concatenated out files
```bash
for model in model_2_1_3 model_2_2_3
do
        for i in {0..99}
        do
                outdir=`printf "output/demography/ms/%s/%02d" $model $i`
                for j in {0..99}
                do
                        outprefix=`printf "%s_%02d_%02d" $model $i $j`
                        if [ -f $outdir/$outprefix.log ];then
                                cat -e $outdir/$outprefix.out | grep "$" | sed 's/\$//' | awk -v n1=$i -v n2=$j -v outprefix=$outprefix 'BEGIN{n=n1*1e4 + n2*1e2}n1==0&&n2==0&&NR==1{print $0}NR>1{$1+=n;print $0}'
                        fi
                done
        done > output/demography/ms/${model}_out.txt
done  

```

Concatenated log files
```bash

for model in model_2_1_3 model_2_2_3
do
        for i in {0..99}
        do
                outdir=`printf "output/demography/ms/%s/%02d" $model $i`
                for j in {0..99}
                do
                        outprefix=`printf "%s_%02d_%02d" $model $i $j`
                        if [ -f $outdir/$outprefix.log ];then
                                cat -e $outdir/$outprefix.log | grep "$" | sed 's/\$//' | awk -v n1=$i -v n2=$j -v outprefix=$outprefix 'BEGIN{n=n1*1e4 + n2*1e2}n1==0&&n2==0&&NR==1{print $0}NR>1{$1+=n;print $0}'
                        fi
                done
        done > output/demography/ms/${model}_log.txt
done  

```



Then I removed output folders



```bash

for model in model_2_1_3 model_2_2_3
do
    bgzip output/demography/ms/${model}_out.txt
    bgzip output/demography/ms/${model}_log.txt
done

```



## Computation of blackcap summary statistics

In the above simulation, I had 1,000 independent sites.
I randomly select independent 1,000 SNPs from the blackcap VCF, convert them to `ms` format, then pipe it to my `ms2stats.awk`
I excluded sites within local PCA outlier regions.


I made list of blackcap IDs orderred the same way as `pop_nhaps.txt` using `sort_blackcap_id.R`, and saved the sorted list in `list/id_sorted.txt`.

```bash
head -n15 list/id_sorted.txt

```
```
G01 cont_Georgia
G02 cont_Georgia
G03 cont_Georgia
G04 cont_Georgia
G05 cont_Georgia
G06 cont_Georgia
O065107 cont_Georgia
O065108 cont_Georgia
O065109 cont_Georgia
O065117 cont_Georgia
O065118 cont_Georgia
O065119 cont_Georgia
C1E2764 cont_medlong
C2L3948 cont_medlong
C1E2800 cont_medlong
```

Then I made a file only with ID


```bash
awk '{print $1}' list/id_sorted.txt > list/id_sorted.list

```

I reordered samples in the blackcap autosome VCF, excluded local PCA outlier regions, thinned SNPs at least 100 kb apart, and sampled 1,000 of them, then computed the summary stats.

```bash

bcftools view -S list/id_sorted.list ../localPCA_phased/input/vcf/autosomes.phased.vcf.gz |\
        vcftools --vcf - --recode --exclude-bed ../localPCA_phased/output/localPCA_MDS/local_PCA_MDS_outlier_islands_merged.bed --thin 100000 -c |\
        bcftools query -f '%CHROM %POS[ %GT]\n' |\
        sed 's/|/ /g' | shuf -n 1000 |\
        awk -v logfile=output/demography/blackcap/sampled_sites.txt -f scripts/tab2ms.awk |\
        awk -v simid=1 -f scripts/ms2stats.awk - list/pop_nhaps.txt > output/demography/blackcap/observed_out.txt
        
```


## ABC

```bash

sbatch scripts/abc_mod_sel.sh

```

### Cross-validation before model selection

![Confusion matrix](output/demography/abc/confusion_mod_sel.pdf)



### Model selection

Multinomial logistic regression.

```
 Call: 
 postpr(target = d_obs_stats, index = sim_models, sumstat = d_stats, 
     tol = 0.01, method = "mnlogistic")
 Data:
  postpr.out$values (79798 posterior samples)
 Models a priori:
  model_1_1_1, model_1_1_2, model_1_2_1, model_1_2_2, model_2_1_1, model_2_1_2, model_2_2_1, model_2_2_2
 Models a posteriori:
  model_1_1_1, model_1_1_2, model_1_2_1, model_1_2_2, model_2_1_1, model_2_1_2, model_2_2_1, model_2_2_2
 Warning: Posterior model probabilities are corrected for unequal number of simulations per models.
 
 
 Proportion of accepted simulations (rejection):
 model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2 
      0.0481      0.1529      0.0173      0.0541      0.1375      0.3521      0.0701      0.1679 
 
 Bayes factors:
             model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
 model_1_1_1      1.0000      0.3144      2.7815      0.8958      0.3510      0.1368      0.6890      0.2862
 model_1_1_2      3.1803      1.0000      8.8459      2.8490      1.1163      0.4351      2.1913      0.9103
 model_1_2_1      0.3595      0.1130      1.0000      0.3221      0.1262      0.0492      0.2477      0.1029
 model_1_2_2      1.1163      0.3510      3.1049      1.0000      0.3918      0.1527      0.7691      0.3195
 model_2_1_1      2.8489      0.8958      7.9240      2.5521      1.0000      0.3898      1.9629      0.8154
 model_2_1_2      7.3091      2.2982     20.3300      6.5477      2.5656      1.0000      5.0360      2.0920
 model_2_2_1      1.4514      0.4564      4.0369      1.3002      0.5095      0.1986      1.0000      0.4154
 model_2_2_2      3.4938      1.0986      9.7178      3.1298      1.2264      0.4780      2.4072      1.0000
 
 
 Posterior model probabilities (mnlogistic):
 model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2 
      0.0005      0.0009      0.0013      0.0002      0.0179      0.8068      0.0154      0.1570 
 
 Bayes factors:
             model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
 model_1_1_1      1.0000      0.5104      0.3466      1.9141      0.0251      0.0006      0.0292      0.0029
 model_1_1_2      1.9594      1.0000      0.6792      3.7506      0.0492      0.0011      0.0572      0.0056
 model_1_2_1      2.8848      1.4723      1.0000      5.5219      0.0725      0.0016      0.0843      0.0083
 model_1_2_2      0.5224      0.2666      0.1811      1.0000      0.0131      0.0003      0.0153      0.0015
 model_2_1_1     39.8003     20.3121     13.7964     76.1827      1.0000      0.0222      1.1625      0.1142
 model_2_1_2   1791.9303    914.5151    621.1547   3429.9774     45.0231      1.0000     52.3382      5.1403
 model_2_2_1     34.2375     17.4732     11.8681     65.5349      0.8602      0.0191      1.0000      0.0982
 model_2_2_2    348.6068    177.9121    120.8410    667.2767      8.7589      0.1945     10.1820      1.0000
```


Neuralnet

```
Call: 
postpr(target = d_obs_stats, index = sim_models, sumstat = d_stats, 
    tol = 0.01, method = "neuralnet")
Data:
 postpr.out$values (79798 posterior samples)
Models a priori:
 model_1_1_1, model_1_1_2, model_1_2_1, model_1_2_2, model_2_1_1, model_2_1_2, model_2_2_1, model_2_2_2
Models a posteriori:
 model_1_1_1, model_1_1_2, model_1_2_1, model_1_2_2, model_2_1_1, model_2_1_2, model_2_2_1, model_2_2_2
Warning: Posterior model probabilities are corrected for unequal number of simulations per models.


Proportion of accepted simulations (rejection):
model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2 
     0.0481      0.1529      0.0173      0.0541      0.1375      0.3521      0.0701      0.1679 

Bayes factors:
            model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
model_1_1_1      1.0000      0.3144      2.7815      0.8958      0.3510      0.1368      0.6890      0.2862
model_1_1_2      3.1803      1.0000      8.8459      2.8490      1.1163      0.4351      2.1913      0.9103
model_1_2_1      0.3595      0.1130      1.0000      0.3221      0.1262      0.0492      0.2477      0.1029
model_1_2_2      1.1163      0.3510      3.1049      1.0000      0.3918      0.1527      0.7691      0.3195
model_2_1_1      2.8489      0.8958      7.9240      2.5521      1.0000      0.3898      1.9629      0.8154
model_2_1_2      7.3091      2.2982     20.3300      6.5477      2.5656      1.0000      5.0360      2.0920
model_2_2_1      1.4514      0.4564      4.0369      1.3002      0.5095      0.1986      1.0000      0.4154
model_2_2_2      3.4938      1.0986      9.7178      3.1298      1.2264      0.4780      2.4072      1.0000


Posterior model probabilities (neuralnet):
model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2 
     0.0000      0.0189      0.0000      0.0011      0.0000      0.8021      0.0000      0.1778 

Bayes factors:
             model_1_1_1  model_1_1_2  model_1_2_1  model_1_2_2  model_2_1_1  model_2_1_2  model_2_2_1  model_2_2_2
model_1_1_1 1.000000e+00 0.000000e+00 1.645930e+01 8.000000e-04 1.413100e+00 0.000000e+00 7.182000e+00 0.000000e+00
model_1_1_2 2.251562e+04 1.000000e+00 3.705914e+05 1.734500e+01 3.181652e+04 2.360000e-02 1.617070e+05 1.064000e-01
model_1_2_1 6.080000e-02 0.000000e+00 1.000000e+00 0.000000e+00 8.590000e-02 0.000000e+00 4.363000e-01 0.000000e+00
model_1_2_2 1.298103e+03 5.770000e-02 2.136587e+04 1.000000e+00 1.834332e+03 1.400000e-03 9.322962e+03 6.100000e-03
model_2_1_1 7.077000e-01 0.000000e+00 1.164780e+01 5.000000e-04 1.000000e+00 0.000000e+00 5.082500e+00 0.000000e+00
model_2_1_2 9.547568e+05 4.240420e+01 1.571463e+07 7.355017e+02 1.349154e+06 1.000000e+00 6.857054e+06 4.510400e+00
model_2_2_1 1.392000e-01 0.000000e+00 2.291700e+00 1.000000e-04 1.968000e-01 0.000000e+00 1.000000e+00 0.000000e+00
model_2_2_2 2.116798e+05 9.401500e+00 3.484102e+06 1.630686e+02 2.991218e+05 2.217000e-01 1.520282e+06 1.000000e+00
```


### Parameter inference

```bash

sbatch scripts/abc_dem_param.sh

```

### Simulation using parameters sampled from posterior distributions

#### ms

```bash

sbatch scripts/sim_ms_posterior.sh

```

I visualised the summary stats of simulated data based on the posterior using plot_ms_posterior_obs.R.
Some of the observed summary stats were outside the range of simulations.




## ABC random forest

### Model selection

```bash

sbatch scripts/abcrf_modsel.sh

```

model_2_1_2 was chosen by the random forest.

```
  selected model votes model1 votes model2 votes model3 votes model4 votes model5 votes model6 votes model7 votes model8 post.proba
1    model_2_1_2            3           52            0           25           45          600           35          240  0.6979167
```

### Parameter inference

I performed `abcrf::regAbcrf` for each of the 36 parameters of model_2_1_2

```bash
for i in {1..36}
do
        sbatch scripts/abcrf_regAbcrf.sh $i
done

```

I performed parameter inference for each of the 36 parameters of model_2_1_2

```bash
for i in {1..36}
do
        sbatch scripts/abcrf_parinf.sh $i
done


```

I summarised the inference using abcrf_parinf_summarise.R.
I used write_config_model_2_1_2_abcrf_posterior_med.R to write config for posterior simulation.

```bash

module load R/4.2.0

model=model_2_1_2

for i in {0..9}
do
        random=`shuf -i 1-1000000000 -n 1`
        command=`Rscript scripts/write_config_model_2_1_2_abcrf_posterior_med.R 1  | awk -v seed=$random -f scripts/write_ms_model_2.awk`
        $command | awk -v simid=1 -f scripts/ms2stats.awk - list/pop_nhaps.txt > output/demography/post_ms_slim/${model}_abcrf_posterior_med_ms_${i}_out.txt
        echo $random >> output/demography/post_ms_slim/${model}_abcrf_posterior_med_ms_${i}_seed.txt
done

```

```bash
awk 'NR==1{split($0, param, " ")}NR==2{split($0, val, " ")}END{for(i=1;i<=length(param);i++){printf "%s %.9e\n", param[i], val[i]}}' output/demography/abcrf/model_2_1_2_posterior_med_for_ms.txt > output/demography/abcrf/model_2_1_2_posterior_med.txt

```






#### SLiM


I wrote the neutral scnenario under the inferred demography in SLiM and ran it to get TreeSeq.
I ran it 10 times to have 10 chromosomes

```bash

for rep in {0..9}
do
        for scale in 50 100
        do
                T0=`awk -v scale=$scale 'BEGIN{print int((2.119920000e+05 - 1.703870000e+04)/scale)}'`
                T1=`awk -v scale=$scale 'BEGIN{print int((2.119920000e+05)/scale)}'`
                sbatch scripts/model_2_1_2_abc_slim.sh $scale $rep $T0 $T1
        done
done

```

I wrote a python script to recapitate the tree seq, sample individuals, throw mutations, and save VCF.


```bash

for rep in {0..9}
do
        for scale in 50 100
        do
                sbatch scripts/model_2_1_2_abc_slim_pyslim.sh output/demography/post_ms_slim/model_2_1_2_posterior_med_${scale}_${rep}.tree output/demography/post_ms_slim/model_2_1_2_slim_pyslim_${scale}_${rep}.vcf $scale
        done
done

```

I bgzipped and indexed the VCF files

```bash

for rep in {0..9}
do
        for scale in 50 100
        do
                bgzip -f output/demography/post_ms_slim/model_2_1_2_slim_pyslim_${scale}_$rep.vcf
                bcftools index output/demography/post_ms_slim/model_2_1_2_slim_pyslim_${scale}_$rep.vcf.gz
        done
done

```

I sampled 1,000 SNPs and summarised the data

```bash

for scale in 50 100
do
        for rep in {0..9}
        do
                bcftools view -m2 -M2 output/demography/post_ms_slim/model_2_1_2_slim_pyslim_${scale}_${rep}.vcf.gz |\
                        bcftools query -f '%CHROM %POS[ %GT]\n' |\
                        sed 's/|/ /g' | shuf -n 1000 |\
                        awk -v logfile=output/demography/post_ms_slim/model_2_1_2_slim_pyslim_log.txt -f scripts/tab2ms.awk |\
                        awk -v simid=1 -f scripts/ms2stats.awk - list/pop_nhaps.txt > output/demography/post_ms_slim/model_2_1_2_slim_pyslim_${scale}_${rep}_out.txt
        done
done

```



#### Comparison with blackcap data

```bash
module load R/4.2.0
Rscript scripts/plot_abcrf_ms_posterior_obs.R


```


# Selection

I have three models to run simulations

+ Neutral
+ Overdominance
    + s
    + h
+ Negative frequency-dependent selection
    + p

For the second and third, I will have 4 scenarios

+ No change in parameter before and after population split
+ Different parameters between continent and islands
+ Different parameters between migrant and resident
+ Different parameters in all populations



## Simulation


Models

1. Overdominance
2. Negative frequency-dependent selection

Scenarios

0. Neutral
1. Constant h and s
2. cont vs isl
3. mig vs res
4. Different h and s for all populations

I prepared output directories

```bash
model=sim_inv_1

for scenario in {0..4}
do
        for rep in {0..99}
        do
                mkdir -p output/inv/slim/$model/$scenario/$rep/
        done
done


model=sim_inv_2
for scenario in {1..4}
do
        for rep in {0..99}
        do
                mkdir -p output/inv/slim/$model/$scenario/$rep/
        done
done

scenario=2
for model in sim_inv_1 sim_inv_2
do
        for rep in {0..99}
        do
                mkdir -p output/inv/slim/$model/$scenario/$rep/
        done
done




```

```bash
model=sim_inv_1
for scenario in {0..4}
do
        for rep in {0..99}
        do
                for rep1 in {0..99}
                do
                        echo sbatch scripts/run_sim_inv.sh $model $scenario ${rep}_${rep1} output/inv/slim/$model/$scenario/$rep
                done
        done
done > scripts/run_sim_inv_sim_inv_1_commands.list


model=sim_inv_2
for scenario in {1..4}
do
        for rep in {0..99}
        do
                for rep1 in {0..99}
                do
                        echo sbatch scripts/run_sim_inv.sh $model $scenario ${rep}_${rep1} output/inv/slim/$model/$scenario/$rep
                done
        done
done > scripts/run_sim_inv_sim_inv_2_commands.list

scenario=2
for model in sim_inv_1 sim_inv_2
do
        for rep in {0..99}
        do
                for rep1 in {0..99}
                do
                        echo sbatch scripts/run_sim_inv.sh $model $scenario ${rep}_${rep1} output/inv/slim/$model/$scenario/$rep
                done
        done
done > scripts/run_sim_inv_rerun_commands.list


```

In screen


```bash

submit_sbatch.sh -i scripts/run_sim_inv_sim_inv_1_commands.list -p slim -r 200 -w 50
submit_sbatch.sh -i scripts/run_sim_inv_sim_inv_2_commands.list -p slim -r 200 -w 50

submit_sbatch.sh -i scripts/run_sim_inv_rerun_commands.list -p slim -r 200 -w 100

```

I concatenated the results and logs.

```bash
model=sim_inv_1
for scenario in {0..4}
do
        for filetype in out log
        do
                for rep in {0..99}
                do
                        for rep1 in {0..99}
                        do
                                cat output/inv/slim/$model/$scenario/$rep/${model}_${scenario}_${rep}_${rep1}_$filetype.txt
                        done
                done | bgzip > output/inv/slim/summary/${model}_${scenario}_$filetype.txt.gz
        done
done 

model=sim_inv_2
for scenario in {1..4}
do
        for filetype in out log
        do
                for rep in {0..99}
                do
                        for rep1 in {0..99}
                        do
                                cat output/inv/slim/$model/$scenario/$rep/${model}_${scenario}_${rep}_${rep1}_$filetype.txt
                        done
                done | bgzip > output/inv/slim/summary/${model}_${scenario}_$filetype.txt.gz
        done
done 



for model in sim_inv_1 sim_inv_2
do
        for filetype in out log
        do
                for scenario in {1..4}
                do
                        for rep in {0..99}
                        do
                                for rep1 in {0..99}
                                do
                                        cat output/inv/slim/$model/$scenario/$rep/${model}_${scenario}_${rep}_${rep1}_$filetype.txt
                                done
                        done 
                done | bgzip > output/inv/slim/summary/${model}_$filetype.txt.gz
        done 
done


cp output/inv/slim/summary/sim_inv_1_0_out.txt.gz output/inv/slim/summary/sim_inv_0_out.txt.gz
cp output/inv/slim/summary/sim_inv_1_0_log.txt.gz output/inv/slim/summary/sim_inv_0_log.txt.gz

```






## ABC

### Model selection

3 models (neutral overdominance vs NFDS)


```bash

sbatch scripts/inv_abcrf_modsel.sh

```


NFDS was chosen

4 scenarios of NFDS model

```bash

sbatch scripts/inv_abcrf_scensel.sh

```


sim_inv_3 (cont vs isl) was chosen


I ran regAbcrf for each of 4 parameters.

```bash

for i in {1..4}
do
        sbatch scripts/inv_abcrf_regAbcrf.sh $i
done

```


I inferred parameters

```bash

for i in {1..4}
do
        sbatch scripts/inv_abcrf_parinf.sh $i
done

```






