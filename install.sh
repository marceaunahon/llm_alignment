#!/bin/bash

# Vérifier si Conda est installé
if command -v conda &>/dev/null; then
    echo "Conda est installé."
else
    echo "Conda n'est pas installé. Veuillez installer Conda et réessayer."
    exit 1
fi

# Nom de l'environnement Conda
ENV_NAME="llm"

# Créer l'environnement Conda s'il n'existe pas
if ! conda env list | grep -q "^${ENV_NAME}"; then
    echo "Création de l'environnement Conda: ${ENV_NAME}"
    conda create -n ${ENV_NAME} python=3.8 -y
else
    echo "L'environnement Conda ${ENV_NAME} existe déjà."
fi

# Activer l'environnement Conda
echo "Activation de l'environnement Conda: ${ENV_NAME}"
source activate ${ENV_NAME}

# Installer les packages à partir de requirements.txt
if [ -f requirements.txt ]; then
    pip install -r requirements.txt
else
    echo "requirements.txt introuvable."
    exit 1
fi
