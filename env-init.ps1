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

# Définir le chemin vers le dossier PHP dans Scoop
$phpPath = (Get-ChildItem "$env:USERPROFILE\scoop\apps\php\" -Directory | Sort-Object Name -Descending | Select-Object -First 1).FullName

# Vérifier si php.ini n'existe pas, mais php.ini-development est présent
$iniPath = Join-Path $phpPath "php.ini"
$devIniPath = Join-Path $phpPath "php.ini-development"

if (-Not (Test-Path $iniPath) -and (Test-Path $devIniPath)) {
    Rename-Item $devIniPath $iniPath
    Write-Output "Renamed php.ini-development to php.ini"
}

# Activer les extensions openssl et curl dans php.ini
(Get-Content $iniPath) | ForEach-Object {
    $_ -replace ';extension=openssl', 'extension=openssl' `
       -replace ';extension=curl', 'extension=curl'
} | Set-Content $iniPath

Write-Output "Activated openssl and curl extensions in php.ini"


# Vérifier si toutes les installations ont réussi
if ($LASTEXITCODE -eq 0) {
    Write-Output "Tous les outils ont été installés avec succès !"
    irm https://github.com/sali6000/Symfony-project-init/raw/main/project-docker-config.ps1 | iex
} else {
    Write-Output "Une erreur s'est produite lors de l'installation de certains outils."
}
