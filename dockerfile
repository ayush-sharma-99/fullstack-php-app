# Dockerfile - Apache + PHP
FROM php:8.2-apache

# Install MySQL client and PHP extensions often used by apps
RUN apt-get update && apt-get install -y default-mysql-client libzip-dev zlib1g-dev unzip git \
  && docker-php-ext-install zip pdo pdo_mysql mysqli \
  && a2enmod rewrite

# Copy app code into apache document root
COPY . /var/www/html/

# Set permissions for web server user
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]

