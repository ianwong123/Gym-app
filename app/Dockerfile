#Official php-fpm 8.3 image
FROM php:8.3-fpm-alpine

#Install database extensions
RUN docker-php-ext-install pdo pdo_mysql

#Setup working directory
WORKDIR /var/www/html

