#!/bin/bash
#SBATCH --job-name=Env  # nom du job
#SBATCH --output=exps/Env%j.out # fichier de sortie (%j = job ID)
#SBATCH --error=exps/Env%j.err # fichier d’erreur (%j = job ID)
#SBATCH --nodes=1 # reserver 2 nœud
#SBATCH --ntasks=1 # reserver 16 taches (ou processus)
#SBATCH --gres=gpu:1 # reserver 8 GPU par noeud
#SBATCH --cpus-per-task=1 # reserver 8 CPU par tache (et memoire associee)
#SBATCH --time=0:10:00 # temps maximal d’allocation "(HH:MM:SS)"
#SBATCH --hint=nomultithread # desactiver l’hyperthreading
#SBATCH --account=aho@v100

# Nom de l'environnement Conda
ENV_NAME="llm"

# Créer l'environnement Conda s'il n'existe pas
if ! conda env list | grep -q "^${ENV_NAME}"; then
    echo "Création de l'environnement Conda: ${ENV_NAME}"
    conda create -n ${ENV_NAME} python=3.11 -y
else
    echo "L'environnement Conda ${ENV_NAME} existe déjà."
fi

# Activer l'environnement Conda
echo "Activation de l'environnement Conda: ${ENV_NAME}"
conda activate ${ENV_NAME}
echo "Environnement Conda activé."

# Installer les packages à partir de requirements.txt
if [ -f requirements.txt ]; then
    pip install -r requirements.txt
else
    echo "requirements.txt introuvable."
    exit 1
fi
echo "Packages installés."