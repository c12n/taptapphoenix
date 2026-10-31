FROM php:8.3-apache

RUN apt-get update \
 && apt-get install -y libsqlite3-dev \
 && docker-php-ext-install pdo_sqlite \
 && rm -rf /var/lib/apt/lists/*

COPY *.php /var/www/html/
RUN mkdir -p /var/www/data && chown -R www-data:www-data /var/www/data

ENV TTP_DATA_DIR=/var/www/data
