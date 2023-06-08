#############################################################
## INITIALIZATION                                          ##
#############################################################
# NAMD3 GPU option
CUDASOAintegrate  on

# Input/Ouput options
set inputname     Ac1-Ac2-solvated
set outputname    equilibration
set common_folder ../../build_files
set restart_file  minimization                  ;# Only used if restart is set to 1
set fep_file      ${common_folder}/fep_tag.pdb  ;# PDB file with -1 and 1 tag at Beta column
set bonds_file    ${common_folder}/bond-restraints.txt

# restart, temp etc.
set restart       1                  ;# 0 - start from scratch, 1 - restart from previous files
set temperature   298.15             ;# Kelvin
set int_step      2.0                ;# integration time step in femtosecond
set freq_energy   1000               ;# print energy every 1000 steps (or 2 picosecond)
set freq_pressure 5000               ;# print pressure every 5000 steps (or 10 picosecond)
set freq_dcd      5000               ;# write trajectory every 5000 steps (or 10 picosecond)

# MD steps
set EquilSteps    500000             ;# (500000 x 2.0fs) = 1 ns per window equilibration
set lambda        CHANGE_LAMBDA                ;# Value of lambda

# PSF and PDB
structure          ${common_folder}/Ac1-Ac2-solvated.psf
coordinates        ${common_folder}/Ac1-Ac2-solvated.pdb

# CHARMM Force Field
paraTypeCharmm     on
parameters         ${common_folder}/Ac1.prm
parameters         ${common_folder}/Ac2.prm
parameters         ${common_folder}/toppar/par_all36m_prot.prm
parameters         ${common_folder}/toppar/par_all36_carb.prm
parameters         ${common_folder}/toppar/par_all36_lipid.prm
parameters         ${common_folder}/toppar/par_all36_na.prm
parameters         ${common_folder}/toppar/par_all36_cgenff.prm
parameters         ${common_folder}/toppar/par_all36_water.prm

#############################################################
## SIMULATION PARAMETERS                                   ##
#############################################################
# Output Options
outputName          $outputname

restartfreq         [expr $freq_dcd*10]
dcdfreq             $freq_dcd
xstFreq             $freq_dcd
outputEnergies      $freq_energy
outputPressure      $freq_pressure

# Restarting from previous run option(s)
if {$restart == 0} {
  # Periodic Boundary Conditions
  # NOTE: Do not set the periodic cell basis if you have also 
  # specified an .xsc restart file!
  cellBasisVector1   40.0   0.0   0.0
  cellBasisVector2    0.0  40.0   0.0
  cellBasisVector3    0.0   0.0  40.0
  cellOrigin          0.0   0.0   0.0 

  # NOTE: Do not set the initial velocity temperature if you 
  # have also specified a .vel restart file!
  temperature       $temperature
  firsttimestep     0

} else {
  # Restart file(s)
  binCoordinates    $restart_file.coor
  binVelocities     $restart_file.vel   ;# remove the "temperature" entry if you use this!
  extendedSystem    $restart_file.xsc
}

# NB Force-Field Parameters
exclude             scaled1-4
1-4scaling          1.0
cutoff              12.
switching           on
switchdist          10.
pairlistdist        13.5

# Integrator Parameters
timestep            $int_step
rigidBonds          all
nonbondedFreq       1
fullElectFrequency  2

# PME (for full-system periodic electrostatics)
PME                 yes
PMEGridSpacing      1.0

wrapWater           on
wrapAll             on

# Constant Temperature Control
langevin            on
langevinDamping     1.0        ;# friction in units of ps^-1
langevinTemp        $temperature
langevinHydrogen    off

# Constant Pressure Control (variable volume)
StrainRate            0.0 0.0 0.0
useGroupPressure      yes      ;# needed for 2fs steps
useFlexibleCell       no       ;# no for water box, yes for membrane
useConstantArea       no       ;# no for water box, yes for membrane
LJCorrection          on       ;# Apply long-range correction for LJ interactions - PBC only

langevinPiston        on
langevinPistonTarget  1.013250 ;#  in bar == 1 atm
langevinPistonPeriod  200.
langevinPistonDecay   100.
langevinPistonTemp    $temperature

#############################################################
## DISTANCE RESTRAINTS - atom-to-atom mapping              ##
#############################################################
extraBonds            on
extraBondsFile        $bonds_file

#############################################################
## ALCHEMICAL CALCULATIONS - Thermodynamic Integration     ##
#############################################################
alch                  on
alchType              ti
alchFile              $fep_file 
alchCol               B
alchOutFile           $outputname.fepout
alchOutFreq           $freq_energy

# Nonbonded Switching
alchVdwLambdaEnd      1.0  ;# make sure the vdW interactions are turned off from lambda=0.0 to 0.7
alchElecLambdaStart   0.5  ;# Start scaling electrostatic interactions at lambda=0.5
alchVdwShiftCoeff     5.0  ;# vdW shift radius
alchDecouple          on   ;# Do decoupling instead of annihilation

# Do TI calc
alchLambda            $lambda
run                   $EquilSteps

