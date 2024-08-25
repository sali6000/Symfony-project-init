Initialisation d'Environnement Symfony avec Docker
Prérequis
Pour utiliser ce projet, assurez-vous d'avoir les éléments suivants installés sur votre machine :

Windows
Visual Studio Code (avec PowerShell intégré)
Présentation
Ce script PowerShell permet d'initialiser un environnement global complet et de préparer un projet Symfony standard avec Docker. Il installe automatiquement toutes les dépendances nécessaires, configurées pour un environnement de développement moderne.

Outils inclus
Le script installe les dernières versions des outils suivants :

Scoop : Gestionnaire de paquets pour Windows.
PHP : Le langage de programmation utilisé par Symfony.
Symfony-CLI : Outil en ligne de commande pour gérer les projets Symfony.
Docker : Conteneurisation des services de votre application.
Composer : Gestionnaire de dépendances PHP.
Git : Gestionnaire de versions pour le contrôle de source.
Node.js : Environnement d'exécution JavaScript.
Webpack Encore : Outil de build frontend pour Symfony.
Utilisation
Pour lancer l'initialisation de l'environnement, il vous suffit de lancer la commande suivante dans PowerShell :

powershell
Copier le code
irm https://github.com/sali6000/Symfony-project-init/raw/main/env-init.ps1 | iex
Le script vous guidera à travers une série de questions pour personnaliser l'installation, comme le nom d'utilisateur, l'email, et le nom du projet.

Fonctionnalités
Installation automatisée des outils nécessaires au développement Symfony avec Docker.
Configuration personnalisée via un script interactif.
Environnement prêt à l'emploi pour démarrer rapidement votre projet Symfony.
