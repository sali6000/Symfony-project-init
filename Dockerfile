FROM php:8.3-fpm

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libicu-dev \
    libonig-dev \
    libzip-dev \
    unzip \
    zip \
    nodejs \
    npm

# Installer les extensions PHP nécessaires
RUN docker-php-ext-install intl pdo pdo_mysql mbstring zip opcache

# Installer Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash - \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Fix des permissions pour éviter les problèmes avec Git
RUN git config --global --add safe.directory /var/www/html

# Définir le dossier de travail
WORKDIR /var/www/html

# Exposer le port PHP-FPM
EXPOSE 9000

# Commande par défaut pour démarrer PHP-FPM
CMD ["php-fpm"]
