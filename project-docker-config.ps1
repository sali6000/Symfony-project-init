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
Remove-Item .\compose.override.yaml, .\compose.yaml
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/Dockerfile -OutFile .\
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/docker-compose.yaml -OutFile .\
mkdir -p ./docker/nginx/conf.d
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/nginx.conf -OutFile .\docker\nginx
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/default.conf -OutFile .\docker\nginx\conf.d

code ./$nameProject

