#!/bin/bash
#PBS -N exomesequencing
#PBS -l walltime=240:00:00
#PBS -l select=1:ncpus=2:mem=4gb
#PBS -q cgsd
#PBS -v USER
module load java
java -Dconfig.file=/groups/cgsd/$USER/gatk-workflows/my.conf \
-jar /groups/cgsd/$USER/cromwell-53.1.jar run \
/groups/cgsd/$USER/gatk-workflows/gatk4-exome-analysis-pipeline/ExomeGermlineSingleSample.wdl \
--inputs \
/groups/cgsd/$USER/gatk-workflows/gatk4-exome-analysis-pipeline/ExomeGermlineSingleSample.inputs.json