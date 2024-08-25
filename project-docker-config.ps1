$username = Read-Host "Please enter the username will be used for git ex: Jonathan, then press ENTER"
$mail = Read-Host "Please enter the mail will be used for git ex: jonathan.tom@gmail.com, then press ENTER"

git config --global user.name $username
git config --global user.email $mail

$nameProject = Read-Host "Please enter the name of project ex: myProject, this name will be used too for DB like myProject_db, then press ENTER"

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

