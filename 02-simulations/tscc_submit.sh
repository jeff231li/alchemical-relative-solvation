#!/bin/bash

#PBS -q home-hopper
#PBS -l walltime=05:00:00
#PBS -l nodes=1:ppn=4:gpu3090
#PBS -W group_list=hopper-group
#PBS -A mgilson-hopper-gpu
#PBS -j oe -r n
#PBS -N CHANGE_WINDOW

Folder=${PBS_O_WORKDIR}
cd ${Folder}/

echo "Current directory: ${PBS_O_WORKDIR}"
echo "PBS job id       : ${PBS_JOBID}"
echo "PBS nodefile     : ${PBS_NODEFILE}"

module load cuda/11.2.0
module load gnu

GPU_id=$CUDA_VISIBLE_DEVICES

NAMD3_folder=/home/jsetiadi/NAMD_3.0alpha9_Linux-x86_64-multicore-CUDA
export PATH=${PATH}:${NAMD3_folder}

# Run NAMD-TI simulations
namd3 +p 4 simulation_ti_min.tcl >& simulation_ti_min.log
namd3 +p 4 simulation_ti_equil.tcl >& simulation_ti_equil.log
namd3 +p 4 simulation_ti_prod.tcl >& simulation_ti_prod.log

exit

