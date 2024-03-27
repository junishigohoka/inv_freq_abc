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
#SBATCH --time=00:05:00
#  maximum requested memory
#SBATCH --mem=12G
#  write std out and std error to these files
#SBATCH --error=/home/ishigohoka/stdout/ms%J.err
#SBATCH --output=/home/ishigohoka/stdout/ms%J.out
#  send a mail for job start, end, fail, etc.
#SBATCH --mail-type=NONE
#SBATCH --mail-user=ishigohoka@evolbio.mpg.de
#  which partition?
#  there are global,testing,highmem,standard,fast
#SBATCH --partition=testing

#  add your code here:

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "sim_ms.sh "
      echo ""
      echo "Simulates using ms and computes population genetic summary statistics"
      echo ""
      echo "options:"
      echo "-h|--help       Show brief help"
      echo "-m|--model      Model. There are three factors"
      echo "                - Georgia: One split vs two splits"
      echo "                - cont_resident: constant vs decrease"
      echo "                - gene flow: nomig, mig"
      echo "                There are 2^3=8 models"
      echo "                model_1_1_1: one split, constant, nomig"
      echo "                model_1_1_2: one split, constant, mig"
      echo "                model_1_2_1: one split, decrease, nomig"
      echo "                model_1_2_2: one split, decrease, mig"
      echo "                model_2_1_1: two splits, constant, nomig"
      echo "                model_2_1_2: two splits, constant, mig"
      echo "                model_2_2_1: two splits, decrease, nomig"
      echo "                model_2_2_2: two splits, decrease, mig"
      echo "-l|--nsites     Number of independent sites to be simulated with ms [1]"
      echo "-n|--nsims      Number of simulation replicates [1]"
      echo "-o|--out        Output prefix [<model>]"
      echo "                Summary stats are written in <out>.out"
      echo "                Sampled parameters and seed are written in <out>.log"
      echo "-p|--popnhaps   Path to a file describing number of haploids per population in two columns: population name; number of haploids"
      echo "-d|--dirawk     Path to directory in which necassary AWK scripts are located [PWD]"
      exit 0
      ;;
    -m|--model)
      shift
      model=$1
      shift
      ;;
    -l|--nsites)
      shift
      nsites=$1
      shift
      ;;
    -n|--nsims)
      shift
      nsims=$1
      shift
      ;;
    -o|--out)
      shift
      out=$1
      shift
      ;;
    -p|--popnhaps)
      shift
      popnhaps=$1
      shift
      ;;
    -d|--dirawk)
      shift
      dirawk=$1
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [ -z $nsims ];then
        nsims=1
fi
if [ -z $nsites ];then
        nsites=1
fi
if [ -z $dirawk ];then
        dirawk=$PWD
fi

if [ -z $popnhaps ];then
        echo "Err: popnhaps missing" 1>&2
        exit
fi
if [ ! -f $popnhaps ];then
        echo "Err: $popnhaps does not exist" 1>&2
        exit
fi

if [ -z $model ];then
        echo "Err: model missing" 1>&2
        exit
fi

modelcheck=`echo $model | awk '/^model_[1-2]_[1-2]_[1-2]$/'`
if [ -z $modelcheck ];then
        echo "Err: model $model is not in the format /^model_[1-2]_[1-2]_[1-2]$/"
        exit
fi


modelfam=`awk -v model=$model 'BEGIN{split(model, model_arr, "_"); print model_arr[1] "_" model_arr[2]}'`




seq $nsims | while read i
do
        random=`shuf -i 1-1000000000 -n 1`
        command=`awk -v simid=$i -v seed=$random -v logfile=$out.log -v nsites=$nsites -f $dirawk/write_config_$model.awk $popnhaps |\
                awk -v seed=$random -f $dirawk/write_ms_$modelfam.awk`
        $command | awk -v simid=$i -f $dirawk/ms2stats.awk - $popnhaps
done > $out.out

