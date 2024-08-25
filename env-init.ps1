# Permettre l'exécution des scripts PowerShell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Vérifier si Scoop est déjà installé
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Output "Scoop est déjà installé. Mise à jour de Scoop..."
    scoop update
} else {
    Write-Output "Installation de Scoop..."
    iwr -useb get.scoop.sh | iex
}

# Ajouter le bucket 'extras' pour des outils supplémentaires comme Docker
Write-Output "Ajout du bucket 'extras'..."
scoop bucket add extras

# Installer les outils nécessaires
Write-Output "Installation de PHP, Symfony CLI, Composer, Docker, Git, et Node.js..."
scoop install php symfony-cli composer docker git nodejs

# Vérifier si toutes les installations ont réussi
if ($LASTEXITCODE -eq 0) {
    Write-Output "Tous les outils ont été installés avec succès !"
    irm https://github.com/sali6000/Symfony-project-init/raw/main/project-docker-config.ps1 | iex
} else {
    Write-Output "Une erreur s'est produite lors de l'installation de certains outils."
}
