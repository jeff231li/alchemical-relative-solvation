# alchemical-relative-solvation
This repository contains bash, TCL and python scripts to perform relative binding solvation free enegy (RHFE) for a transforming a molecule to another. The calculation is performed with NAMD3 version alpha 9 multicore-CUDA. The free energy is obtained with thermodynamic integration (TI).

# Dependencies
The scripts here will require some libraries, which I will list and go through the installation process. 

> **_NOTE:_** The libraries we will use will only work on Linux and MacOS. For Windows, you will need to install [WSL](https://learn.microsoft.com/en-us/windows/wsl/).

If you don't already have Anaconda installed in your machine, then go to https://anaconda.org and install version 3. Most of the dependencies will be included when we install pAPRika. I recommend installing pAPRika in a fresh `conda` environment. 

These are the steps to install pAPRika:
1. Download [the latest release](https://github.com/GilsonLabUCSD/pAPRika/releases), extract it, and change to the `paprika` directory:
2. Change the `name` field in `devtools/conda-envs/test_env.yaml` to be `paprika`.
3. Create the environment: `conda env create -f devtools/conda-envs/test_env.yaml`.
4. Activate the environment: `conda activate paprika`
5. Install `paprika` in the environment: `pip install .`

# Tutorial
I broke this up into three sections:
1. [01-build-files](01-build_files) System preparation for the molecule in a water box.
2. [02-simulations](02-simulations) Alchemical Molecular Dynamics (MD) Simulations.
3. [03-analyze_TI.ipynb](03-analyze_TI.ipynb) Analysis of MD simulations and extract free energy.

The first section will create the PSF and PDB files using PSFGEN. This assumes that we already have both molecules aligned to their maximum common structure (MCS). The second part we run alchemical MD simulations in NAMD over 11 windows. In the final step we analyze the output from the simulations and integrate the derivatives to get the free energy.