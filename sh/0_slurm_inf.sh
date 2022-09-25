#!/bin/bash
#Trent 2022
#Run jobs through slurm

SECONDS=0

echo -e "~~~   ***   ~~~"
echo -e "    slurmie.sh    "
echo -e "~~~         ~~~"


# Defaults
fastie="../../../../../jane/echidna_chr.fa"
covie="../../data/TA_fetus_T8A_sorted.deduplicated.bismark.cov"
annie="../../data/mTacAcu1_pri_genomic.gff"
winnie=1000000 # 1 Mb "window" or "chunk"


# Extract flagged variables
while getopts f:c:a:w: flag
do
	case "${flag}" in
		f) fastie=${OPTARG};;
		v) covie=${OPTARG};;
		a) annie=${OPTARG};;
		w) winnie=${OPTARG};;
	esac
done

# Make fastarget
rm -f ../dep/fastarget.py
touch ../dep/fastarget.py
destdir=../dep/fastarget.py
# Set info
# first wipes ">", second adds ">"
echo "# fastarget.py" > $destdir
echo "# Reference genome (.fa):" >> $destdir
echo "fasf = '"$fastie"'" >> $destdir
echo "# Global loop variables" >> $destdir
echo "winzy ="$winnie >> $destdir

# Make covtarget
ctar=../dep/covtarget.py
rm -f $ctar
touch $ctar
# Set info
echo "# covtarget.py" > $ctar
echo "# Coverage file loc" >> $ctar
echo " " >> $ctar
echo "covf = '"$covie"'" >> $ctar

# Make anntarget
atar=../dep/anntarget.py
rm -f $atar
touch $atar
# Set info
echo "# anntarget.py" > $atar
echo "# Annotation file loc" >> $atar
echo " " >> $atar
echo "annf = '"$annie"'" >> $atar

# Print notes
echo -e "\nFasta (f) file: "$fastie
echo -e "\nWindow, chunk, (c) size: "$winnie
echo -e "Note, don't recommend changing window size."
echo -e "\nCoverage (c) file: "$covie
echo -e "\nAnnotation (a) file: "$annie


# Prepare out file
echo -e "\nBASH: prepare out0";
rm -rf ../out0
mkdir ../out0
mkdir ../out0/wins
mkdir ../out0/gffdb
mkdir ../out0/cgi
mkdir ../out0/cov

# Make .slurm

echo -e "\njob starting..." 


# Slurm folder

echo -e "\nBASH: make .slurm file";

# Variables
jdir=../slurm

jnam=0_cinf.slurm


# Refresh job folder
cd $jdir
rm -f runn* #remove prev run files
rm -f 0_cinf-slurm* #remove prev output file
rm -f $jnam


# Set job info -------------------------------

touch $jnam

echo "#!/bin/bash" > $jnam
echo "# Trent 2022" >> $jnam 
echo "# "$jnam".slurm" >> $jnam
echo "" >> $jnam
echo "# Request computing resources" >> $jnam
echo "#SBATCH --nodes=1" >> $jnam
echo "#SBATCH --ntasks=1" >> $jnam
echo "#SBATCH --time=4:00:00" >> $jnam
echo "#SBATCH --mem-per-cpu=8G" >> $jnam
echo "#SBATCH --job-name=\"sh-1\"" >> $jnam
echo "#SBATCH --output=0_cinf-slurm.out" >> $jnam
echo "" >> $jnam
echo "# Environment variables" >> $jnam
echo -e "echo \"SLURM_JOBID=\"\$SLURM_JOBID" >> $jnam
echo -e "echo \"SLURM_JOB_NODELIST=\"\$SLURM_JOB_NODELIST" >> $jnam
echo -e "echo \"SLURM_NNODES=\"\$SLURM_NNODES" >> $jnam
echo -e "echo \"SLURMTMPDIR=\"\$SLURMTMPDIR" >> $jnam
echo -e "echo \"SLURM_SUBMIT_DIR=\"\$SLURM_SUBMIT_DIR" >> $jnam
echo "" >> $jnam
echo "# Load required modules" >> $jnam
echo -e "echo \"\n###\"" >> $jnam
echo -e "echo \"\nLoading modules\"" >> $jnam
echo -e "echo \"\n###\n\"" >> $jnam
echo "module purge" >> $jnam
echo "module load gcccore/8.3.0" >> $jnam
echo "module load python/3.7.4" >> $jnam
echo "# -> python packages" >> $jnam
echo "pip install --user tqdm | grep -v 'already satisfied'" >> $jnam
echo "pip install --user matplotlib | grep -v 'already satisfied'" >> $jnam
echo "pip install --user pysam | grep -v 'already satisfied'" >> $jnam
echo "pip install --user Bio | grep -v 'already satisfied'" >> $jnam
echo "pip install --user gffutils | grep -v 'already satisfied'" >> $jnam
echo "pip install --user dask | grep -v 'already satisfied'" >> $jnam
echo "" >> $jnam
echo "# Scripts" >> $jnam
echo -e "echo \"\n\n###\"" >> $jnam
echo -e "echo \"\nRunning scripts\"" >> $jnam
echo -e "echo \"\n###\n\"" >> $jnam
echo "time srun -n 1 sh ../sh/0_cinf.sh" >> $jnam
echo "" >> $jnam

echo "# tehehe" >> $jnam
# ------------------------------------------------------------



# Submit job
echo -e "\nBASH: submit job";
cd $jdir
sbatch $jnam



duration=$SECONDS

echo -e "\n~~~ end ~~~"
echo -e "~~~ *** ~~~"

