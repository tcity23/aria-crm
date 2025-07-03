FROM php:8.2-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    unzip zip git libzip-dev libpng-dev libonig-dev libxml2-dev libicu-dev libldap2-dev libpq-dev \
    && docker-php-ext-install mysqli pdo pdo_mysql gd zip intl exif ldap

# Enable Apache mods
RUN a2enmod rewrite headers

# Set working directory
WORKDIR /var/www/html

# Copy files
COPY . .

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Fix permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 775 /var/www/html/data

# Expose port
EXPOSE 80
