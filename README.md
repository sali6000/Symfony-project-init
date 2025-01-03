## Initialisation d'un projet Symfony avec Docker (Windows)

### Prérequis
##### Pour utiliser ce projet, assurez-vous d'avoir les éléments suivants d'installés sur votre machine :
###### - Une connection internet
###### - Docker Desktop (installation et lancement du programme)
###### - En 1 seul commande PowerShell, vous recevez 10 minutes plus tard, un projet docker comprennant symfony 7 et toute les dépendances d'un projet moyen à volumineu dans un seul conteneur



### Présentation
##### Ce script PowerShell permet d'initialiser un environnement global complet afin de préparer un projet Symfony standard avec Docker et MySQL. Il installe automatiquement toutes les dépendances nécessaires et configure un environnement de développement moderne en une seul ligne de commande.


### Outils inclus
Le script installe les dernières versions des outils suivants :

###### - PHP 8.3 (dans l'image Docker du projet) : Le langage de programmation utilisé par Symfony.

###### - Symfony-CLI (dans l'image Docker du projet) : Outil en ligne de commande pour gérer les projets Symfony.

###### - Composer (dans l'image Docker du projet) : Gestionnaire de dépendances PHP.

###### - Git (dans l'image Docker du projet) : Gestionnaire de versions pour le contrôle de source.

###### - Node.js (dans l'image Docker du projet) : Environnement d'exécution JavaScript.

###### - Webpack Encore (dans l'image Docker du projet) : Outil de build frontend pour Symfony.



### Utilisation

##### Pour lancer l'initialisation complète de l'environnement, il vous suffit de lancer la commande suivante dans le terminal (PowerShell) de Visual Studio Code :

```powershell
irm https://github.com/sali6000/Symfony-project-init/raw/main/env-init.ps1 | iex
```
###### Le script vous guidera à travers une série de questions pour personnaliser l'installation de votre projet et de sa base de donnée. Comme le nom d'utilisateur, l'email, et le nom du projet.

### Avantages
##### 1. Installation automatisé des outils nécessaires au développement d'un projet Symfony avec Docker.
##### 2. Configuration personnalisée via un script interactif.
##### 3. Environnement prêt à l'emploi pour démarrer rapidement votre projet Symfony.
