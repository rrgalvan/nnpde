#!/bin/bash 
#SBATCH --job-name=test_tf  	 # name that the job will have in the queue (not related to file names)
#SBATCH --nodes=1                # total number of nodes to use
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --partition=gpu 
#SBATCH --gres=gpu:A100:1	 # gpu:name:number_of_gpus_per_node
#SBATCH --output=slurm%J.out     # name of the file where SLURM will put messages ( %J is the job ID )
#SBATCH --error=slurm%J.err      # name of the file where SLURM will put error messages
#####################
# INFO
# 
# - All the lines beginning with "#SBATCH " will be interpreted by SLURM
#   (If you write more #'s , SLURM will consider them as comments)
# - The lines above are usually the minimum amount of lines to run an MPI job 
# - You may not write some of them and leave the system to use the defaults (not recommended)
# - Ask support / read the documentation to know about hardware config, max. walltime, etc.
# - The *important* thing for pure MPI jobs:
#     - If you want to use all the cores of all the requested nodes,
#       "ntasks" must be equal to "nodes"*{cores in one node}  (ask support if you don't know),
#       and you must always set cpus-per-task=1  (so that each MPI task will use 1 core)
#     - You may need to create less MPI tasks than the total number of cores in all the nodes
#       (e.g. if you need lots of memory and need to sum the memory of many nodes, but you don't 
#       need too many processes). In that case, you can write cpus-per-task=2 (or bigger)
#       and divide "ntasks" by 2 compared to the actual physical total number of cores.
#
# - Other possibly useful SLURM options: 
#####SBATCH --constraint=blabla   # E.g. o send the job to some specific queue, or to use a specific kind of nodes...
#####SBATCH --mem=300G            # To request a specific minimum amount of memory (usually not needed, but some 
#####                             # machines request that you specify it to know whether to send the job to the fat nodes 
#####SBATCH --exclusive           # To request that the nodes assigned to this job will be used only by this
#####                             # and not other job of any user (usually not needed)
#####SBATCH --reservation         # If you are going to use some reserved nodes

# - Now we execute the program
# - You may need to use the command "mpiexec" or maybe "srun"
# - In principle you don't need to write "mpiexec -n 64 ..." because 
# when we wrote "ntasks" earlier the system already knows how many processes to create
# - You may need to write a line that says "export OMP_NUM_THREADS=1"  when the program was built
#   as a hybrid MPI+OpenMP executable, but you want to run it as pure MPI
# 

# Now we load the modules needed for our executable:
module purge
module load Anaconda3          # and then all the messages produced when loading the different modules
module load CUDA
module load tensorflow          # and then all the messages produced when loading the different modules
module list                # and finally the modules that are loaded just before executing

date
echo "lspci | grep -i nvidia:"
lspci | grep -i nvidia

echo ""
echo "hostname:"
hostname

echo ""
echo "nvidia: nvcc -V"
nvcc -V

echo "nvidia-smi..."
nvidia-smi

echo ""
echo "tensorflow:"
python3 /home/mat/u75544533/tests/tensorflow/print_num_gpus.py
echo ""

date
echo "Runing test..."
python3 1_nonlinear_regression.py

echo "... done."
date

