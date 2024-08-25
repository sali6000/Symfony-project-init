# Récupérer les valeurs actuelles de user.name et user.email
$currentName = git config --global user.name
$currentEmail = git config --global user.email

# Demander si l'utilisateur veut modifier user.name
Write-Host "Do you want to change the Git user.name $currentName ? (y/n)" -ForegroundColor Yellow
$modifyName = Read-Host
if ($modifyName -eq "y") {
    Write-Host "Please enter the new Git user.name" -ForegroundColor Cyan
    $username = Read-Host
    git config --global user.name $username
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
    git config --global user.email $mail
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

symfony new $nameProject --webapp
# webapp inclut par défaut:
# Twig : pour les templates.
# Doctrine : pour l'accès à la base de données.
# Security Bundle : pour la gestion des utilisateurs et de l'authentification.
# Asset Bundle : pour la gestion des assets (CSS, JS, images).
# Symfony UX : pour ajouter une intégration avec Stimulus et Symfony UX components.

cd ./$nameProject

(Get-Content ./.env) -replace '^(DATABASE_URL=).+', "DATABASE_URL=`"mysql://root:rootpassword@mysql:3306/$nameProject`_db?serverVersion=8.0`" # Dev" | Set-Content ./.env

# Supprimer les fichiers de configuration Docker existants
Remove-Item .\compose.override.yaml, .\compose.yaml -Force

# Télécharger les fichiers nécessaires
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/Dockerfile -OutFile .\Dockerfile
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/docker-compose.yaml -OutFile .\docker-compose.yaml

# Créer les dossiers requis
mkdir -p .\docker\nginx\conf.d

# Télécharger les fichiers Nginx dans les dossiers corrects
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/nginx.conf -OutFile .\docker\nginx\nginx.conf
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/default.conf -OutFile .\docker\nginx\conf.d\default.conf

# Ouvrir le projet dans VS Code
code ./$nameProject

