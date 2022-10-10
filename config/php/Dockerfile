# image
FROM php:8.1-apache

# Set php
COPY ./php.ini /usr/local/etc/php/

# Set apache
COPY ./apache2.conf /etc/apache2/
COPY ./sites/*.conf /etc/apache2/sites-available/
RUN mv /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
RUN /bin/sh -c a2enmod rewrite

# Install
RUN apt-get update
RUN apt-get install -y libonig-dev
RUN apt-get install -y zip
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install wget
RUN apt-get clean

# composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# node
RUN apt-get install -y nodejs npm && npm install n -g && n 18.10.0

# yarn
RUN wget https://github.com/yarnpkg/yarn/releases/download/v1.22.19/yarn_1.22.19_all.deb
RUN dpkg -i yarn_1.22.19_all.deb

# mysql
RUN docker-php-ext-install pdo_mysql mysqli