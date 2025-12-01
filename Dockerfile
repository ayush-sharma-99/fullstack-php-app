# Use official PHP + Apache image
FROM php:8.1-apache

# Install extensions needed (mysqli for MySQL)
RUN apt-get update && apt-get install -y \
    libzip-dev unzip \
  && docker-php-ext-install mysqli pdo pdo_mysql zip \
  && a2enmod rewrite \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Copy app files
COPY . /var/www/html

# Ensure correct permissions
RUN chown -R www-data:www-data /var/www/html \
  && chmod -R 755 /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]

