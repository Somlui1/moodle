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
RUN a2enmod rewrite ssl
RUN a2ensite default-ssl

# Configure Apache DocumentRoot and SSL certificates
ENV APACHE_DOCUMENT_ROOT /var/www/html/moodle/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN sed -i 's|/etc/ssl/certs/ssl-cert-snakeoil.pem|/etc/ssl/certs/aapico_2026.crt|g' /etc/apache2/sites-available/default-ssl.conf
RUN sed -i 's|/etc/ssl/private/ssl-cert-snakeoil.key|/etc/ssl/private/aapico_2026.key|g' /etc/apache2/sites-available/default-ssl.conf

# Create Moodle Data Directory and set permissions
RUN mkdir -p /var/moodledata && \
    chown -R www-data:www-data /var/moodledata && \
    chmod -R 777 /var/moodledata

# Setup working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

# The base image already has a default CMD ["apache2-foreground"]
