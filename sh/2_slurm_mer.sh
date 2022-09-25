#!/bin/bash
#Trent 2021
#Run jobs through slurm


SECONDS=0

echo -e "~~~   ***   ~~~"
echo -e "    slurmie.sh    "
echo -e "~~~         ~~~"



# Make .slurm
echo -e "\njob starting..." 
# Slurm folder
echo -e "\nBASH: make .slurm file";


# Defaults:
#c=chr7
ccc='22' # X1

# Extract flagged variables
while getopts c: flag
do
    case "${flag}" in
        c) ccc=${OPTARG};;
    esac
done

row=$(expr $ccc + 1) # row 1 is header

# Trick to get output of awk as variable...
cee=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -F',' 'NR == '$row' { print $1 }' ../out0/contig_info.csv`
ceem=$(expr $cee + 1)
connie=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -F',' 'NR == '$row' { print $2 }' ../out0/contig_info.csv`
sizzie=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -F',' 'NR == '$row' { print $3 }' ../out0/contig_info.csv`
wnp=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -F',' 'NR == '$row' { print $4 }' ../out0/contig_info.csv`
wn=$(( wnp - 1 )) # Maximum number for coding

echo " ";
echo "ceem: "$ceem;
echo "Selected contig: "$connie;
echo "Contig size: "$sizzie" (bp)";
echo "Total windows: "$wnp;
echo " ";


# Prepare out file
echo -e "\nBASH: prepare out2/"$connie;
#rm -rf ../out2/$connie
mkdir ../out2/$connie
mkdir ../out2/$connie/cgicov
mkdir ../out2/$connie/anno

# Variables
jdir=../slurm/
rm -rf $jdir
mkdir $jdir
# Refresh job folder
cd $jdir
rm -f 2_bin-run_con-$ccc* #remove prev run files
rm -f 2_bin-slurm-out_con-$ccc_* #remove prev output file



START=0
END=$wn
for w in $(eval echo "{$START..$END}")
do
	# set job info -------------------------------
	jnam="2_bin-run_con-"$ccc"_win-"$w".slurm"
	touch $jnam
	echo "#!/bin/bash" > $jnam
	echo "# trent 2021" >> $jnam 
	echo "# "$jnam"" >> $jnam
	echo "" >> $jnam
	echo "# Request computing resources" >> $jnam
	echo "#SBATCH --nodes=1" >> $jnam
	echo "#SBATCH --ntasks=1" >> $jnam
	echo "#SBATCH --time=00:30:00" >> $jnam
	echo "#SBATCH --job-name=\"2-"$ccc"-"$w"\"" >> $jnam
	echo "#SBATCH --output=\"2_bin-slurm-out_con-"$ccc"_win-"$w".out\"" >> $jnam
	echo "" >> $jnam
	echo "# Environment variables" >> $jnam
	echo -e "echo \"SLURM_JOBID=\"\$SLURM_JOBID" >> $jnam
	echo -e "echo \"SLURM_JOB_NODELIST=\"\$SLURM_JOB_NODELIST" >> $jnam
	echo -e "echo \"SLURM_NNODES=\"\$SLURM_NNODES" >> $jnam
	echo -e "echo \"SLURMTMPDIR=\"\$SLURMTMPDIR" >> $jnam
	echo -e "echo \"SLURM_SUBMIT_DIR=\"\$SLURM_SUBMIT_DIR" >> $jnam
	echo "" >> $jnam
	echo "# Load required modules" >> $jnam
	echo -e "echo \"Loading modules\n\"" >> $jnam
	echo "module purge" >> $jnam
	echo "module load gcccore/8.3.0" >> $jnam
	echo "module load python/3.7.4" >> $jnam
	echo "# -> python packages" >> $jnam
	echo "pip install --user tqdm | grep -v 'already satisfied'" >> $jnam
	echo "pip install --user matplotlib | grep -v 'already satisfied'" >> $jnam
	echo "pip install --user pysam | grep -v 'already satisfied'" >> $jnam
	echo "pip install --user Bio | grep -v 'already satisfied'" >> $jnam
	echo "pip install --user gffutils | grep -v 'already satisfied'" >> $jnam
	echo "" >> $jnam
	echo "# Scripts" >> $jnam
	echo -e "echo \"Running scripts\"" >> $jnam
	echo "time srun -n 1 sh ../sh/2_merg.sh -c "$connie" -w "$w >> $jnam
	echo "" >> $jnam
	echo "# tehehe" >> $jnam
	# ------------------------------------------------------------

	# Submit job
	echo -e "\nBASH: submit job "$jnam
	sbatch $jnam
done



duration=$SECONDS

echo -e "\n~~~ end ~~~"
echo -e "~~~ *** ~~~"

