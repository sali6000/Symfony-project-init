FROM php:8.3-fpm

# Install necessary dependencies
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

# Install PHP extensions
RUN docker-php-ext-install intl pdo pdo_mysql mbstring zip opcache


# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash - \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Set working directory
WORKDIR /var/www/html

# Create and use a non-root user
RUN useradd -ms /bin/bash symfonyuser

# Switch to root to configure Git
USER root
# Fix Git ownership issue by marking /var/www/html as a safe directory
RUN git config --global --add safe.directory /var/www/html

# Switch back to non-root user for running Symfony commands
USER symfonyuser

# Create a new Symfony project
RUN symfony new . --webapp

# Ensure the correct permissions for the user on the working directory before running composer
USER root
RUN chown -R symfonyuser:symfonyuser /var/www/html

# Switch back to non-root user for running Composer
USER symfonyuser

# Install project dependencies with Composer
RUN composer install --no-interaction --optimize-autoloader --prefer-dist

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
