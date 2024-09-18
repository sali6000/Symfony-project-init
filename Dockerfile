FROM php:8.3-fpm

#  Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libicu-dev \
    libpq-dev \
    libonig-dev \
    libzip-dev \
    unzip \
    zip \
    nodejs \
    npm
# Détails des paquets installés :
# git : Système de versionnement distribué, souvent utilisé pour cloner des dépôts lors de la construction de conteneurs.
# curl : Outil de ligne de commande pour transférer des données avec des URL. Peut être utilisé par PHP ou des scripts pour effectuer des requêtes HTTP.
# libicu-dev : Bibliothèque internationale utilisée pour la gestion des encodages de texte, l'internationalisation, et la localisation dans les applications PHP (souvent utilisée par l'extension PHP intl).
# libpq-dev : En-têtes et bibliothèques de développement pour PostgreSQL, nécessaire si tu utilises PostgreSQL avec PHP.
# libonig-dev : Dépendance pour la bibliothèque Oniguruma utilisée pour la gestion des expressions régulières en PHP, notamment par l'extension mbstring.
# libzip-dev : Fichiers de développement pour la gestion des archives ZIP. Nécessaire pour l'extension PHP zip.
# unzip : Utilitaire pour décompresser les fichiers .zip. Utilisé pour extraire des archives, par exemple lors de l'installation de paquets avec Composer.
# zip : Utilitaire pour compresser des fichiers en .zip, souvent utilisé pour générer des archives compressées.

# Pourquoi ces dépendances sont-elles nécessaires ?
# PHP Extensions : Certaines extensions PHP requièrent des bibliothèques système pour fonctionner correctement. Par exemple, libicu-dev est nécessaire pour l'extension intl, et libzip-dev pour l'extension zip.
# Outils de construction : Certains outils, comme git et curl, sont utiles lors de la construction d'un conteneur pour récupérer du code, des packages ou des données.

# Install PHP extensions
RUN docker-php-ext-install intl pdo pdo_mysql mbstring zip opcache

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash - \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

    # Install Symfony and Composer
RUN symfony new . --webapp

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Create and use a non-root user
RUN useradd -ms /bin/bash symfonyuser

# Switch to root to install Symfony CLI
USER root

# Install Symfony CLI directly into /usr/local/bin
RUN curl -sS https://get.symfony.com/cli/installer | bash - && \
    mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Switch back to non-root user
USER symfonyuser

# Copy existing application directory contents
COPY . .

# Run composer with COMPOSER_ALLOW_SUPERUSER=1
RUN export COMPOSER_ALLOW_SUPERUSER=1 && composer install --no-interaction --optimize-autoloader --prefer-dist

# Change ownership of var directory
USER root
RUN chown -R www-data:www-data /var/www/html/var/cache

# Ensure that Symfony commands are run correctly
RUN export SYMFONY_DEPRECATIONS_HELPER=weak && composer dump-autoload --optimize

# Run cache clear as root, then revert to symfonyuser
USER root
RUN rm -rf /var/www/html/var/cache/*
RUN php bin/console cache:clear
USER symfonyuser

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
