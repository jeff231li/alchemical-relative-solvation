# Load in solvated molecules
mol new     Ac1-Ac2-solvated.psf
mol addfile Ac1-Ac2-solvated.pdb

# ------------------------------------------------------ #
# Write Bond Restraints File
# ------------------------------------------------------ #
# Select heavy atoms from each ligand
set lig_ref [atomselect top "resname AC1 and noh"]
set lig_target [atomselect top "resname AC2 and noh"]

# Write to file
set f [open "bond-restraints.txt" w]
set kbond 100.0       ;# kcal/mol/A^2
set bond_distance 0.0 ;# Angstrom

foreach atomi [$lig_ref get index] atomj [$lig_target get index] {
	puts $f [format "bond $atomi $atomj $kbond $bond_distance"]
}
close $f

# ------------------------------------------------------ #
# Write PDB file with tags for alchemical calculations
# ------------------------------------------------------ #
set all [atomselect top "all"]
$all set beta 0.0
$all set occupancy 0.0

# Outgoing atoms (-1) and Incoming atoms (1)
set lig_ref [atomselect top "resname AC1"]
set lig_target [atomselect top "resname AC2"]
$lig_ref set beta -1.0
$lig_target set beta 1.0

$all writepdb fep_tag.pdb

exit
