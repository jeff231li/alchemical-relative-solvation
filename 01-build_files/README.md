# Building PSF and PDB
In this part, I assume we already have the molecules superposed together based on the maximum common structure (MCS). Here, we also need the topology (rtf) and parameter (prm) files of our molecule. If not, we will need to generate those in CHARMM-GUI or AmberTools. For this tutorial I will focus on the files we get from CHARMM-GUI.

We can also extend the tutorial here to relative binding free energy. Once we have an equilibrated protein+ligand+membrane system (including the full PSF file), we can add the PSF and PDB of the target ligand molecule. Of course, you will need to align the molecule somehow with some other tools. This is how to combine two PSF/PDB files together in PSFGEN inside the VMD TKConsole:
```TCL
package require psfgen
resetpsf

# Load Protein-ligand system
readpsf protein-ligand-membrane.psf pdb protein-ligand-membrane.pdb

# Load target Ligand system
readpsf target-ligand.psf pdb target-ligand.pdb

# Write new PSF/PDB file 
writepsf protein-ligand-complex.psf
writepdb protein-ligand-complex.pdb

exit
```
You can run the above in the TKConsole or save it to a file and run it on the command line
```bash
vmd -dispdev text -e combine_structures.tcl
```

In the file [01-build_dual_ligand.tcl](01-build_dual_ligand.tcl), I did the following:
* Build the PSF/PDB file for the two ligands (reference and target) in a vacuum
* Shift the molecules to the origin
* Solvate the molecules in a 40 Angstrom cubic box
* Regenerate the PSF/PDB files with water -- the VMD solvate sometimes can mess up the PSF file, so it's safer to regenerate it with PSFGEN.

Take a look at the TCL file to understand what is being done. Finally, run the following on the terminal to generate solvated system:
```bash
vmd -dispdev text -e 01-build_dual_ligand.tcl
```

# Writing Restraints file and tagging molecules
Next, we need to generate a NAMD restraints file (based on `extraBonds`, see [NAMD documentation](https://www.ks.uiuc.edu/Research/namd/2.14/ug/node29.html#SECTION00086400000000000000)). Essentially, we need to apply an atom-to-atom distance restraint for the atoms belonging to the MCS. This is one of the quirks of the dual-topology paradigm. For the example here the two ligand molecules have the same structure and number of molecules. The only difference is where the double is in the aromatic ring. For target ligands with different number of atoms you will need find the MCS atoms yourself.

In the file [02-write_restraints_fep_file.tcl](02-write_restraints_fep_file.tcl), I set the force constant for the atom-to-atom distance restraint to 100 kcal/mol/Angstrom^2.

Finally, I tagged the beta column for the reference ligand to -1.0 and the target to 1.0. In NAMD, atoms tagged with -1.0 represents atoms that are "outgoing" and 1.0 represents atoms that are "incoming".
```bash
vmd -dispdev text -e 02-write_restraints_fep_file.tcl
```