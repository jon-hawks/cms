################################################################################
# Package Apache, PHP, and the CMS.                                             #
################################################################################
# PHP 8.3 preserves compatibility with the CMS's own mb_ucfirst() function.
FROM php:8.3-apache

# Install database, CAPTCHA, and socket support.
RUN apt-get update && apt-get install -y --no-install-recommends \
        libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo_mysql sockets \
    && rm -rf /var/lib/apt/lists/*

# Caddy handles HTTPS; Apache serves PHP on port 8080 inside the pod.
RUN a2enmod rewrite remoteip \
    && sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf \
    && echo 'session.save_path=/var/lib/php/sessions' > /usr/local/etc/php/conf.d/cms.ini
COPY .apache.conf /etc/apache2/conf-enabled/cms.conf

# Copy source; .dockerignore excludes credentials and persistent data.
COPY . /var/www/html/
