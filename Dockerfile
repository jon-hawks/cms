# syntax=docker/dockerfile:1

# PHP and Apache; serves /var/www/html on loopback port 8080.
FROM php:apache

RUN <<'EOF'
set -e

# GD build dependencies: fonts, JPEG, PNG.
apt-get update
apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev

# PHP extensions: images, MySQL, WebSockets.
docker-php-ext-configure gd --with-freetype --with-jpeg
docker-php-ext-install gd pdo_mysql sockets

# Remove downloaded package indexes.
rm -rf /var/lib/apt/lists/*

# Apache: CMS routes and client IPs behind a proxy.
a2enmod rewrite remoteip

# Keep Apache inside the pod; Caddy owns the public HTTP and HTTPS listeners.
printf '%s\n' 'Listen 127.0.0.1:8080' > /etc/apache2/ports.conf
sed -i 's/<VirtualHost \*:80>/<VirtualHost 127.0.0.1:8080>/' /etc/apache2/sites-available/000-default.conf

# Keep sessions in the mounted volume.
echo 'session.save_path=/var/lib/php/sessions' > "$PHP_INI_DIR/conf.d/cms.ini"
EOF

# CMS routing and proxy settings.
COPY .apache.conf /etc/apache2/conf-enabled/cms.conf

# Application; .dockerignore excludes credentials and persistent data.
COPY . /var/www/html/
