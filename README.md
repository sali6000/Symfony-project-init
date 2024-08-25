## Initialisation d'Environnement Symfony avec Docker

### Prérequis
##### Pour utiliser ce projet, assurez-vous d'avoir les éléments suivants d'installés sur votre machine :
###### - Windows

###### - Visual Studio Code

###### - Docker Desktop



### Présentation
##### Ce script PowerShell permet d'initialiser un environnement global complet et de préparer un projet Symfony standard avec Docker et MySQL. Il installe automatiquement toutes les dépendances nécessaires et configure un environnement de développement moderne et sans artifices.


### Outils inclus
Le script installe les dernières versions des outils suivants :

###### - Scoop : Gestionnaire de paquets pour Windows.

###### - PHP : Le langage de programmation utilisé par Symfony.

###### - Symfony-CLI : Outil en ligne de commande pour gérer les projets Symfony.

###### - Docker : Conteneurisation des services de votre application.

###### - Composer : Gestionnaire de dépendances PHP.

###### - Git : Gestionnaire de versions pour le contrôle de source.

###### - Node.js : Environnement d'exécution JavaScript.

###### - Webpack Encore : Outil de build frontend pour Symfony.



### Utilisation

###### Pour lancer l'initialisation complète de l'environnement, il suffit simplement de lancer la commande suivante dans le terminal (PowerShell) de Visual Studio Code :

```powershell
irm https://github.com/sali6000/Symfony-project-init/raw/main/env-init.ps1 | iex
```

#### Le script vous guidera à travers une série de questions pour personnaliser l'installation de votre projet et de sa base de donnée. Comme le nom d'utilisateur, l'email, et le nom du projet.

### Fonctionnalités
###### - Installation automatisée des outils nécessaires au développement Symfony avec Docker.
###### - Configuration personnalisée via un script interactif.
###### - Environnement prêt à l'emploi pour démarrer rapidement votre projet Symfony. localhost:8080 vous souhaitera la bienvenue ainsi que PhpMyAdmin sur localhost:8081
