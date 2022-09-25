#!/bin/bash
#Trent 2022
#loop slurm submission loop script



SECONDS=0

echo -e "~~~   ***   ~~~"
echo -e "    run        "
echo -e "~~~         ~~~"



# Make .slurm
echo -e "\nstarting..." 
echo -e " "

cnum=$(cat ../out0/contig_info_sel.csv | wc -l)
echo "no of contigs: "$cnum;
echo -e " "

sleep 2

START=1
END=$cnum

for cn in $(eval echo "{$START..$END}")
do
	echo $cn
	nam=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -F',' 'NR == '$cn' { print $2 }' ../out0/contig_info_sel.csv`
	echo $nam
	bash 2_slurm_mer.sh -c $cn
	#sleep 1
	echo -e " "
done


