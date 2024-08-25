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

# Étape 1: Obtenir la version de PHP installée via Scoop
$phpVersionOutput = & "$HOME\scoop\apps\php\current\php.exe" -v
$phpVersion = $phpVersionOutput | Select-String -Pattern "^PHP (\d+\.\d+\.\d+)" | ForEach-Object { $_.Matches[0].Groups[1].Value }

# Étape 2: Formater la version pour Dockerfile (ex: 8.3.10 -> 8.3)
$phpMajorMinor = $phpVersion -replace '(\d+\.\d+)\.\d+', '$1'

# Étape 3: Chemin du Dockerfile
$dockerfilePath = "$HOME\$nameProject\Dockerfile"

# Étape 4: Lire le contenu du Dockerfile
$dockerfileContent = Get-Content $dockerfilePath

# Étape 5: Modifier la ligne `FROM php:...`
$dockerfileContent = $dockerfileContent -replace 'FROM php:\d+\.\d+-fpm', "FROM php:$phpMajorMinor-fpm"

# Étape 6: Écrire les modifications dans le Dockerfile
Set-Content -Path $dockerfilePath -Value $dockerfileContent

Write-Host "Dockerfile updated to use PHP version $phpMajorMinor-fpm" -ForegroundColor Green



# Mettre à jour docker-compose.yaml
$dockerComposePath = "$HOME\$nameProject\docker-compose.yaml"
if (Test-Path $dockerComposePath) {
    (Get-Content $dockerComposePath) -replace 'MYSQL_DATABASE: \w+', "MYSQL_DATABASE: ${nameProject}_db" | Set-Content $dockerComposePath
    Write-Host "docker-compose.yaml updated with database name ${nameProject}_db" -ForegroundColor Green
} else {
    Write-Host "docker-compose.yaml not found. Ensure you are in the correct directory." -ForegroundColor Red
}





# Créer les dossiers requis
mkdir -p .\docker\nginx\conf.d

# Télécharger les fichiers Nginx dans les dossiers corrects
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/nginx.conf -OutFile .\docker\nginx\nginx.conf
Invoke-RestMethod -Uri https://github.com/sali6000/Symfony-project-init/raw/main/default.conf -OutFile .\docker\nginx\conf.d\default.conf

# Ajout des fichiers de configs mis à jours dans le dépôt Git
git add .
git commit -m "Ajout des fichiers de configuration dans le dépôt Git"

# Ajout du Webpack Encore
composer require symfony/webpack-encore-bundle

# Afficher le message à l'utilisateur
Write-Host "Veuillez lancer Docker Desktop (Windows) et ensuite revenir sur cette fenêtre pour continuer." -ForegroundColor Cyan
Write-Host "Appuyez sur ENTER lorsque c'est fait (Fenêtre en attente...)" -ForegroundColor Cyan

# Attendre que l'utilisateur appuie sur Enter pour continuer
$null = Read-Host

# Vérifier que Docker est prêt (Docker Desktop doit être lancé et opérationnel)
$dockerRunning = $false
while (-not $dockerRunning) {
    try {
        # Tester si Docker est prêt en vérifiant les informations sur Docker
        $dockerInfo = docker info 2>&1
        
        # Si la commande `docker info` retourne une chaîne vide ou un résultat spécifique en cas d'erreur, on la traite ici
        if ($dockerInfo -notmatch "Cannot connect to the Docker daemon" -and $dockerInfo -notmatch "error during connect") {
            $dockerRunning = $true
        } else {
            throw "Docker daemon n'est pas prêt."
        }
    } catch {
        Write-Host "Docker n'est pas encore prêt. Assurez-vous que Docker Desktop est lancé. Nouvelle tentative de connexion dans 5 secondes" -ForegroundColor Yellow
        Start-Sleep -Seconds 5
    }
}

Write-Host "Docker Desktop est prêt. Continuation du script..." -ForegroundColor Green


# Exécuter la commande docker-compose pour construire l'image et lancer les services en arrière-plan
docker-compose up -d --build

# Exécuter la commande pour créer la base de données
docker exec -it $nameProject-php-1 php bin/console doctrine:database:create

Write-Host "FIN de l'installation ! Vous pouvez continuer sur la nouvelle fenêtre et fermer celle-çi. Bonne continuation !" -ForegroundColor Green

# Ouvrir le projet dans VS Code
code $HOME/$nameProject

