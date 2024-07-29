#!/bin/bash
#SBATCH --job-name=JAX_TDMPC # nom du job
#SBATCH --output=JAX_TDMPC%j.out # fichier de sortie (%j = job ID)
#SBATCH --error=JAX_TDMPC%j.err # fichier d’erreur (%j = job ID)
#SBATCH --nodes=1 # reserver 1 noeud
#SBATCH --ntasks=1 # reserver 1 taches (ou processus)
#SBATCH --array=0-5 # pour avoir 5 fois la meme exp (differentes seed)
#SBATCH --gres=gpu:1 # reserver 1 GPU 
#SBATCH --cpus-per-task=10 # reserver 10 CPU par tache (et memoire associee)
#SBATCH --time=05:00:00 # temps maximal d’allocation "(HH:MM:SS)"

#SBATCH --hint=nomultithread         # hyperthreading desactive


module purge # nettoyer les modules herites par defaut
conda deactivate # desactiver les environnements herites par defaut
module load python/3.10.4
conda activate jax_tdmpc310

set -x # activer l’echo des commandes

export ADDITIONAL=""
# choose Algo Presets:
source ./bash/set_sac.sh # 
# choose Task Presets:
export TASK_CFG=pointmaze/u_maze.yaml

echo "START"
python $LAUNCH_SCRIPT algo=$ALGO task=$TASK_CFG wandb_mode=offline $ADDITIONAL
echo "FINISHED"