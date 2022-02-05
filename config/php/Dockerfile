# image
FROM php:8.0-apache

# Set php
COPY ./php.ini /usr/local/etc/php/

# Set apache
COPY ./apache2.conf /etc/apache2/
COPY ./sites/*.conf /etc/apache2/sites-available/
RUN mv /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
RUN /bin/sh -c a2enmod rewrite

# Install
RUN apt update \
  && apt install -y libpq-dev \
  && apt install -y libonig-dev \
  && apt install -y git \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt install -y nodejs \
  && apt install wget \
  && wget https://github.com/yarnpkg/yarn/releases/download/v1.3.2/yarn_1.3.2_all.deb \
  && dpkg -i yarn_1.3.2_all.deb \
  && docker-php-ext-install pdo_mysql pdo_pgsql mysqli mbstring
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer