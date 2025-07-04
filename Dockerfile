FROM php:8.2-apache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy app files
COPY . /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libldap2-dev \
    && docker-php-ext-install ldap

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Run Composer install
RUN composer install --no-dev --optimize-autoloader

# Set file permissions (optional but recommended)
RUN chown -R www-data:www-data /var/www/html
