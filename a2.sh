#!/bin/bash
#SBATCH --job-name=Test1  # nom du job
#SBATCH --output=exps/Test1%j.out # fichier de sortie (%j = job ID)
#SBATCH --error=exps/Test1%j.err # fichier d’erreur (%j = job ID)
#SBATCH --constraint=a100
#SBATCH --nodes=1 # reserver 2 nœud
#SBATCH --ntasks=1 # reserver 16 taches (ou processus)
#SBATCH --gres=gpu:1 # reserver 8 GPU par noeud
#SBATCH --cpus-per-task=1 # reserver 8 CPU par tache (et memoire associee)
#SBATCH --time=0:10:00 # temps maximal d’allocation "(HH:MM:SS)"
#SBATCH --hint=nomultithread # desactiver l’hyperthreading
#SBATCH --account=aho@a100
module purge # nettoyer les modules herites par defaut
module load cpuarch/amd # selectionner les modules compiles pour AMD
module load pytorch-gpu/py3/2.0.0 # charger les modules
set -x # activer l’echo des commandes
srun python -m src.evaluate --experiment-name "jz_first_test" --dataset "kill" --model "google/flan-t5-small" --question-types "ab"  --eval-nb-samples 1 --dataset-folder "paperlaws"  # executer son script
