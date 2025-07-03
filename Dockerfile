FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install mysqli pdo pdo_mysql zip gd exif \
    && a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy app files into container
COPY . .

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Expose Apache
EXPOSE 80
