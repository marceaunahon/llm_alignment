#!/bin/bash
#SBATCH --job-name=kill # nom du job
#SBATCH --output=exp6_xl/kill%j.out # fichier de sortie (%j = job ID)
#SBATCH --error=exps6_xl/kill%j.err # fichier d’erreur (%j = job ID)
#SBATCH --constraint v100-32g
#SBATCH --nodes=1 # reserver 2 nœud
#SBATCH --ntasks=1 # reserver 16 taches (ou processus)
#SBATCH --gres=gpu:0 # reserver 8 GPU par noeud
#SBATCH --cpus-per-task=1 # reserver 8 CPU par tache (et memoire associee)
#SBATCH --time=20:00:00 # temps maximal d’allocation "(HH:MM:SS)"
#SBATCH --hint=nomultithread # desactiver l’hyperthreading
#SBATCH --account=aho@cpu
module purge # nettoyer les modules herites par defaut
module load cpuarch/amd # selectionner les modules compiles pour AMD
module load pytorch-gpu/py3/2.0.0 # charger les modules
set -x # activer l’echo des commandes
srun python -m src.evaluate --experiment-name "jz/greedy/no_rule" --dataset "kill" --model "google/flan-t5-xl" --question-types "ab" "repeat" "compare"  --eval-technique "greedy" --eval-nb-samples 1 --dataset-folder "paperlaws" # executer son script
echo "C'est tout bon"