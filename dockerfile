FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libbz2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libicu-dev \
    libldap2-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions
# These are extensions found in php.ini that are not default in the php:apache image
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) \
        bz2 \
        gd \
        gettext \
        intl \
        ldap \
        mysqli \
        pdo_mysql \
        soap \
        zip \
        exif \
        opcache

# Enable Apache modules
RUN a2enmod rewrite

# Setup working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

# The base image already has a default CMD ["apache2-foreground"]
