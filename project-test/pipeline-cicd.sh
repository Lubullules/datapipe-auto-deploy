#!/bin/bash

# Vérifier si un argument a été fourni
if [ -z "$1" ]; then
    echo "❌ Erreur: Veuillez spécifier une branche (dev ou master)."
    exit 1
fi

# Récupérer la branche depuis l'argument
branch="$1"

# Définir la variable `env` et la `terraform_key` en fonction de `branch`
if [ "$branch" == "dev" ]; then
    env="dev"
    terraform_key="terraform_state_folder_dev/terraform_state"
elif [ "$branch" == "master" ]; then
    env="prod"
    terraform_key="terraform_state_folder_prod/terraform_state"
else
    echo "❌ Erreur: La branche '$branch' n'est pas reconnue. Utilisez 'dev' ou 'master'."
    exit 1
fi

# Sourcing du fichier d'environnement correspondant
config_file=".config/.env.$env"

if [ -f "$config_file" ]; then
    source "$config_file"
    echo "✅ Environnement chargé: $env"
else
    echo "❌ Erreur: Le fichier de configuration '$config_file' n'existe pas."
    exit 1
fi

# Exécuter Terraform init avec la bonne configuration backend
echo "🚀 Initialisation de Terraform..."
terraform init -reconfigure \
    -backend-config="region=eu-west-1" \
    -backend-config="bucket=aws-base-albert-project-ve-eu-west-1" \
    -backend-config="key=$terraform_key"

if [ $? -ne 0 ]; then
    echo "❌ Erreur: Échec de l'initialisation de Terraform."
    exit 1
fi

# Exécuter Terraform plan et stocker le plan dans un fichier
echo "🔍 Génération du plan Terraform..."
terraform plan -out=plan

if [ $? -ne 0 ]; then
    echo "❌ Erreur: Terraform plan a échoué."
    exit 1
fi

# Demander validation à l'utilisateur avant d'appliquer les changements
echo "⚠️  Voulez-vous appliquer ce plan ? (yes/no)"
read -r response
if [[ "$response" == "yes" ]]; then
    echo "🚀 Déploiement en cours..."
    terraform apply --auto-approve plan
    if [ $? -eq 0 ]; then
        echo "✅ Déploiement terminé avec succès !"
    else
        echo "❌ Erreur lors de l'application du plan Terraform."
        exit 1
    fi
else
    echo "❌ Déploiement annulé."
    exit 1
fi