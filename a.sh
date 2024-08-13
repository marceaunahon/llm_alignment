#!/bin/bash
#SBATCH --job-name=  # nom du job
#SBATCH --output=Collect%j.out # fichier de sortie (%j = job ID)
#SBATCH --error=Collect%j.err # fichier d’erreur (%j = job ID)
#SBATCH --nodes=1 # reserver 2 nœud
#SBATCH --ntasks=1 # reserver 16 taches (ou processus)
#SBATCH --gres=gpu:1 # reserver 8 GPU par noeud
#SBATCH --cpus-per-task=1 # reserver 8 CPU par tache (et memoire associee)
#SBATCH --time=0:10:00 # temps maximal d’allocation "(HH:MM:SS)"
#SBATCH --hint=nomultithread # desactiver l’hyperthreading
#SBATCH --account=aho@v100
module purge # nettoyer les modules herites par defaut
module load cpuarch/amd # selectionner les modules compiles pour AMD
module load pytorch-gpu/py3/2.0.0 # charger les modules
set -x # activer l’echo des commandes
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "break_law"
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "break_promise"
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "cheat"
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "deceive"
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "disable"
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "duty"
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "freedom"
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "kill"
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "pain"
srun python -m src.collect --experiment-name "jz/greedy/no_rule" --dataset "pleasure"

srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "break_law"
srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "break_promise"
srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "cheat"
srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "deceive"
srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "disable"
srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "duty"
srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "freedom"
srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "kill"
srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "pain"
srun python -m src.collect --experiment-name "jz/greedy/rule" --dataset "pleasure"

srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "break_law"
srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "break_promise"
srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "cheat"
srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "deceive"
srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "disable"
srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "duty"
srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "freedom"
srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "kill"
srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "pain"
srun python -m src.collect --experiment-name "jz/top_p/rule" --dataset "pleasure"

srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "break_law"
srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "break_promise"
srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "cheat"
srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "deceive"
srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "disable"
srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "duty"
srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "freedom"
srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "kill"
srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "pain"
srun python -m src.collect --experiment-name "jz/top_p/no_rule" --dataset "pleasure"
