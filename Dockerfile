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
# Use an official PHP + Apache image
FROM php:8.1-apache

# Install system deps and PHP extensions commonly used in PHP apps
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
  && docker-php-ext-install pdo_mysql mbstring xml gd \
  && rm -rf /var/lib/apt/lists/*

# Enable apache mod_rewrite (often needed)
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy composer and install if composer.json exists
COPY composer.json composer.lock* /var/www/html/ 2>/dev/null || true

# Install composer (only if composer.json is present)
RUN if [ -f composer.json ]; then \
      php -r "copy('https://getcomposer.org/installer','composer-setup.php');" && \
      php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
      composer install --no-interaction --no-dev --optimize-autoloader && \
      rm -f composer-setup.php ; \
    fi

# Copy application source
COPY . /var/www/html

# Fix permissions (adjust user/group if needed)
RUN chown -R www-data:www-data /var/www/html \
 && find /var/www/html -type d -exec chmod 755 {} \; \
 && find /var/www/html -type f -exec chmod 644 {} \;

# Expose port 80
EXPOSE 80

# Default command
CMD ["apache2-foreground"]
# Use a supported PHP + Apache base
FROM php:8.2-apache

# Install system deps & PHP extensions commonly needed for PHP apps
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo_mysql mysqli zip mbstring xml \
    && a2enmod rewrite

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy app
COPY . /var/www/html

# Set permissions (adjust if your app uses different directories)
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && find /var/www/html -type d -exec chmod 755 {} \;

# Optional: install vendor packages if composer.json present
RUN if [ -f /var/www/html/composer.json ]; then \
      cd /var/www/html && composer install --no-dev --optimize-autoloader; \
    fi

EXPOSE 80
CMD ["apache2-foreground"]

