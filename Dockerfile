# Ce fichier Dockerfile crée une image Docker personnalisée prête pour développer et exécuter des applications Symfony. 
# Il installe toutes les dépendances nécessaires (PHP, outils front-end, gestionnaires de dépendances) 
# et configure un environnement stable pour traiter les requêtes PHP via PHP-FPM.

# Utilise l'image officielle PHP avec PHP-FPM (FastCGI Process Manager) pour exécuter des applications PHP.
FROM php:8.3-fpm

# Met à jour les paquets existants et installe les dépendances nécessaires à l'environnement du projet.
RUN apt-get update && apt-get install -y \
    # Outil de gestion de version pour le suivi et le partage du code source.
    git \
    # Outil en ligne de commande pour effectuer des requêtes HTTP.
    curl \
    # Bibliothèque pour les fonctionnalités d'internationalisation.
    libicu-dev \
    # Bibliothèque nécessaire pour le support des expressions régulières dans PHP (utilisée avec `mbstring`).
    libonig-dev \
    # Bibliothèque pour la manipulation des fichiers ZIP, essentielle pour les projets PHP modernes.
    libzip-dev \
    # Utilisé pour extraire des fichiers ZIP.
    unzip \
    # Utilisé pour créer des fichiers ZIP.
    zip \
    # Plateforme JavaScript côté serveur (utilisée par Webpack Encore ou des outils JS dans Symfony).
    nodejs \
    # Gestionnaire de paquets JavaScript associé à Node.js.
    npm


# Installe les extensions PHP nécessaires pour le projet Symfony.
RUN docker-php-ext-install intl pdo pdo_mysql mbstring zip opcache
    # intl : Support pour l'internationalisation (traductions, formats de date/heure).
    # pdo et pdo_mysql : Extensions pour la connexion à une base de données MySQL.
    # mbstring : Manipulation des chaînes de caractères multi-octets (Unicode).
    # zip : Gestion des fichiers compressés ZIP.
    # opcache : Accélère les performances PHP en mettant en cache les scripts compilés.

# Installe l'outil Symfony CLI pour gérer les projets Symfony.
RUN curl -sS https://get.symfony.com/cli/installer | bash - \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony
    # Télécharge et installe Symfony CLI.
    # Déplace l'exécutable dans un répertoire accessible globalement.

# Ajoute Composer (gestionnaire de dépendances PHP) depuis l'image officielle "composer".
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Fixe un problème potentiel avec les permissions des fichiers lors de l'utilisation de Git dans les conteneurs.
RUN git config --global --add safe.directory /var/www/html

# Définit le répertoire de travail par défaut où le code de l'application sera copié.
WORKDIR /var/www/html

# Ouvre le port 9000, utilisé par PHP-FPM pour traiter les requêtes.
EXPOSE 9000

# Définit la commande par défaut à exécuter lorsque le conteneur démarre.
CMD ["php-fpm"]
    # Lance PHP-FPM, qui attendra et traitera les requêtes PHP transmises par un serveur web comme Nginx.
