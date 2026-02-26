#!/bin/bash
#
# How much RAM per CPU?
#$ -t 1-10000
#$ -l cpu=1
#$ -l h_vmem=12G
#$ -l h_rt=00:30:00
# Merge stdout and stderr. The job will create only one output file which
# contains both the real output and the error messages.
#$ -N ms
#$ -j n
#$ -o logs/sim_ms_qsub_$JOB_ID.$TASK_ID.out
#$ -e logs/sim_ms_qsub_$JOB_ID.$TASK_ID.err
# Use /bin/bash to execute this script
#Run job from current working directory
#$ -cwd





while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "sim_ms_qsub.sh "
      echo ""
      echo "Simulates using ms and computes population genetic summary statistics"
      echo "This was written for revision"
      echo ""
      echo "options:"
      echo "-h|--help       Show brief help"
      echo "-m|--model      Model. There are three factors"
      echo "                There are 2 models"
      echo "                model_2_1_3: Geo first, constant, more splits"
      echo "                model_2_2_3: Geo first, decrease, more splits"
      echo "-l|--nsites     Number of independent sites to be simulated with ms [1]"
      echo "-n|--nsims      Number of simulation replicates [1]"
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

modelcheck=`echo $model | awk '/^model_2_[1-2]_3$/'`
if [ -z $modelcheck ];then
        echo "Err: model $model is not in the format /^model_2_[1-2]_3$/"
        exit
fi






i=$(((SGE_TASK_ID - 1)/ 100))
j=$(((SGE_TASK_ID - 1) % 100))



outdir=`printf "output/demography/ms/%s/%02d" $model $i`
outprefix=`printf "%s_%02d_%02d" $model $i $j`

out=$outdir/$outprefix



seq $nsims | while read kk
do
        k=$((kk - 1))
        random=`shuf -i 1-1000000000 -n 1`
        command=`awk -v simid=$k -v seed=$random -v logfile=$out.log -v nsites=$nsites -f $dirawk/write_config_$model.awk $popnhaps |\
                awk -v seed=$random -f $dirawk/write_ms_$model.awk`
        $command | awk -v simid=$k -f $dirawk/ms2stats.awk - $popnhaps
done > $out.out


