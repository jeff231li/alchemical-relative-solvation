package require psfgen
package require solvate

# ------------------------------------------------------ #
# Build initial PSF/PDB in vacuum
# ------------------------------------------------------ #
resetpsf

# Load topologies
topology toppar/top_all36_cgenff.rtf
topology Ac1.rtf
topology Ac2.rtf

segment AC1 {
	pdb ac1_molecule.pdb
}
coordpdb ac1_molecule.pdb AC1

segment AC2 {
	pdb ac2_molecule.pdb
}
coordpdb ac2_molecule.pdb AC2

writepsf ac1_ac2.psf
writepdb ac1_ac2.pdb

# ------------------------------------------------------ #
# Shift molecule to center
# ------------------------------------------------------ #
mol new ac1_ac2.psf
mol addfile ac1_ac2.pdb

set all [atomselect top "all"]
$all moveby [vecinvert [measure center $all weight mass]]
$all writepdb ac1_ac2.centered.pdb

# Write Ac1 molecule 
set ac1 [atomselect top "resname AC1"]
$ac1 writepdb ac1.centered.pdb

# Write Ac2 molecule 
set ac2 [atomselect top "resname AC2"]
$ac2 writepdb ac2.centered.pdb

# ------------------------------------------------------ #
# Solvate
# ------------------------------------------------------ #
solvate ac1_ac2.psf ac1_ac2.centered.pdb -o ac1_ac2_solvated -minmax {{-20 -20 -20} {20 20 20}}

mol new ac1_ac2_solvated.psf 
mol addfile ac1_ac2_solvated.pdb

# Write water box to PDB
set sel [atomselect top "water"]
$sel writepdb water.pdb

# ------------------------------------------------------ #
# Rewrite PSF and PDB with all components
# ------------------------------------------------------ #
resetpsf

topology toppar/top_all36_cgenff.rtf
topology Ac1.rtf
topology Ac2.rtf
topology toppar/toppar_water_ions.str

segment AC1 {
	pdb ac1.centered.pdb
}
coordpdb ac1.centered.pdb AC1

segment AC2 {
	pdb ac2.centered.pdb
}
coordpdb ac2.centered.pdb AC2

segment WT1 {
	pdb water.pdb
}
coordpdb water.pdb WT1

writepsf Ac1-Ac2-solvated.psf
writepdb Ac1-Ac2-solvated.pdb

exit
