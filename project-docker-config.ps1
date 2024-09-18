# Arrêter l'exécution en cas d'erreur
$ErrorActionPreference = "Stop"

# Activer la sortie détaillée
$VerbosePreference = "Continue"

# Se placer dans le répertoire de l'utilisateur
cd $HOME

# Permettre l'exécution des scripts PowerShell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Récupérer les valeurs actuelles de user.name et user.email
$currentName = git config --global user.name
$currentEmail = git config --global user.email

# Demander si l'utilisateur veut modifier user.name
Write-Host "Do you want to change the Git user.name $currentName ? (y/n)" -ForegroundColor Yellow
$modifyName = Read-Host
if ($modifyName -eq "y") {
    Write-Host "Please enter the new Git user.name" -ForegroundColor Cyan
    $username = Read-Host
    RUN git config --global user.name $username
    Write-Host "Git user.name updated to $username" -ForegroundColor Green
} else {
    Write-Host "Git user.name remains as $currentName" -ForegroundColor Green
}

# Demander si l'utilisateur veut modifier user.email
Write-Host "Do you want to change the Git user.email $currentEmail ? (y/n)" -ForegroundColor Yellow
$modifyEmail = Read-Host
if ($modifyEmail -eq "y") {
    Write-Host "Please enter the new Git user.email" -ForegroundColor Cyan
    $mail = Read-Host
    RUN git config --global user.email $mail
    Write-Host "Git user.email updated to $mail" -ForegroundColor Green
} else {
    Write-Host "Git user.email remains as $currentEmail" -ForegroundColor Green
}

# Demander le nom du projet
Write-Host "Please enter the name of the project (e.g., myProject). This name will also be used for the DB (e.g., myProject_db). Press ENTER after entering." -ForegroundColor Cyan
$nameProject = Read-Host

# Boucle de confirmation
$confirmation = $false
while (-not $confirmation) {
    Write-Host "You entered: $nameProject. Is this correct? (y/n)" -ForegroundColor Yellow
    $response = Read-Host
    
    if ($response -eq "y") {
        $confirmation = $true
        Write-Host "Project name confirmed as $nameProject" -ForegroundColor Green
    } elseif ($response -eq "n") {
        Write-Host "Please enter the name of the project again:" -ForegroundColor Cyan
        $nameProject = Read-Host
    } else {
        Write-Host "Please answer with 'y' or 'n'." -ForegroundColor Red
    }
}

# Créer les répertoires ded base servant à initialiser la base du projet
mkdir -p $nameProject
cd .\$nameProject
mkdir -p .\docker\nginx\conf.d

# Répertoire temporaire pour le téléchargement
$tempPath = [System.IO.Path]::GetTempPath()

# URLs des fichiers à télécharger
$nginxConfUrl = "https://github.com/sali6000/Symfony-project-init/raw/main/nginx.conf"
$defaultConfUrl = "https://github.com/sali6000/Symfony-project-init/raw/main/default.conf"
$dockerfileUrl = "https://github.com/sali6000/Symfony-project-init/raw/main/Dockerfile"
$composeUrl = "https://github.com/sali6000/Symfony-project-init/raw/main/docker-compose.yaml"

# Fichiers temporaires pour le téléchargement
$tempNginxConf = Join-Path -Path $tempPath -ChildPath "nginx.conf"
$tempDefaultConf = Join-Path -Path $tempPath -ChildPath "default.conf"
$tempDockerfile = Join-Path -Path $tempPath -ChildPath "Dockerfile"
$tempCompose = Join-Path -Path $tempPath -ChildPath "docker-compose.yaml"

# Télécharger les fichiers dans le répertoire temporaire
Invoke-RestMethod -Uri $nginxConfUrl -OutFile $tempNginxConf
Invoke-RestMethod -Uri $defaultConfUrl -OutFile $tempDefaultConf
Invoke-RestMethod -Uri $dockerfileUrl -OutFile $tempDockerfile
Invoke-RestMethod -Uri $composeUrl -OutFile $tempCompose

Copy-Item -Path $tempNginxConf -Destination $HOME/$nameProject/docker/nginx
Copy-Item -Path $tempDefaultConf -Destination $HOME/$nameProject/docker/nginx/conf.d
Copy-Item -Path $tempDockerfile -Destination $HOME/$nameProject
Copy-Item -Path $tempCompose -Destination $HOME/$nameProject

# Supprimer les fichiers temporaires
Remove-Item -Path $tempNginxConf, $tempDefaultConf, $tempDockerfile, $tempCompose -Force

docker-compose build
docker-compose up -d
docker-compose exec php bash
