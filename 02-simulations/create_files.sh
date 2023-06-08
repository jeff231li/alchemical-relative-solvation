#!/bin/bash

lambda_values=(0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0)

j=0
for lb in "${lambda_values[@]}"
do
	if [ $j -lt 10 ] ; then jj=00${j} ; else jj=0${j} ; fi
	echo "creating files for $lb ${jj}"

	folder=t${jj}
	mkdir -p ${folder}
	cd ${folder}/

	cp ../../tscc_submit.sh jq01
	cp ../../simulation_ti_min.tcl .
	cp ../../simulation_ti_equil.tcl .
	cp ../../simulation_ti_prod.tcl .

	sed -i "s,CHANGE_WINDOW,t${jj},g" jq01
	sed -i "s,CHANGE_LAMBDA,${lb},g" simulation_ti_min.tcl
	sed -i "s,CHANGE_LAMBDA,${lb},g" simulation_ti_equil.tcl
	sed -i "s,CHANGE_LAMBDA,${lb},g" simulation_ti_prod.tcl

	# Uncomment below to submit job in TSCC
	#qsub jq01

	cd ../

	j=$(expr $j + 1)
done

