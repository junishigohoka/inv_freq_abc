#!/bin/bash
#
# How much RAM per CPU?
#$ -l h_vmem=100G
#$ -pe parallel 16
#$ -l h_rt=120:00:00
# Merge stdout and stderr. The job will create only one output file which
# contains both the real output and the error messages.
#$ -N abcrf
#$ -j n
#$ -o logs/abcrf_$JOB_ID.$TASK_ID.out
#$ -e logs/abcrf_$JOB_ID.$TASK_ID.err
# Use /bin/bash to execute this script
#Run job from current working directory
#$ -cwd



#  add your code here:



# unset EDITOR
# unset VISUAL
# unset TERM
# export R_LIBS_USER=/fml/ag-pallares/jishigohoka/R/x86_64-pc-linux-gnu-library/4.2
#

/fml/ag-pallares/jishigohoka/miniforge3/envs/project/bin/Rscript scripts/abcrf_modsel.R


