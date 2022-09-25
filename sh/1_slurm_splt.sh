#!/bin/bash
#Trent 2022
#Run jobs through slurm

SECONDS=0

echo -e "~~~   ***   ~~~"
echo -e "    slurmie.sh    "
echo -e "~~~         ~~~"


# Prepare out file
echo -e "\nBASH: prepare out1";
rm -rf ../out1
mkdir ../out1
mkdir ../out1/gffdb_split
mkdir ../out1/cgi_split
mkdir ../out1/cov_split

# Make .slurm

echo -e "\njob starting..." 


# Slurm folder

echo -e "\nBASH: make .slurm file";

# Variables
jdir=../slurm

jnam=1_wsplittie.slurm


# Refresh job folder
cd $jdir
rm -f runn* #remove prev run files
rm -f 1_wsplit* #remove prev output file
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
echo "#SBATCH --time=1:00:00" >> $jnam
echo "#SBATCH --mem-per-cpu=8G" >> $jnam
echo "#SBATCH --job-name=\"sh-1\"" >> $jnam
echo "#SBATCH --output=1_wsplt-slurm.out" >> $jnam
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
echo "time srun -n 1 sh ../sh/1_wsplit.sh" >> $jnam
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

