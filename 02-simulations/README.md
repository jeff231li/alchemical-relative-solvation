# Running the simulations
Here, I create 11 windows that represents the lambda points from 0 to 1. For each window I perform the following:
* 1000 steps of energy minimization - [simulation_ti_min.tcl](simulation_ti_min.tcl)
* 1ns of equilibration - [simulation_ti_equil.tcl](simulation_ti_equil.tcl)
* 2ns of production - [simulation_ti_prod.tcl](simulation_ti_prod.tcl)

Run the bash script to create the windows and copy all the necessary files.
```bash
bash create_files.sh
```

The simulations were done with the CUDA version of NAMD3 alpha 9.0.