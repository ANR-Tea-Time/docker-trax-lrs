FROM php:8.2-apache

LABEL version="0.1"
LABEL maintainer="remi.venant@univ-lemans.fr"
LABEL description="Trax instance for dev"

# Pour eviter à l'install de trax l'exigence de mongo et redis
ENV COMPOSER_IGNORE_PLATFORM_REQ=ext-mongodb,ext-redis

# On se place dans un dossier temporaire d'installation pour assurer un nettoyage correcte à la fin
WORKDIR /tmp

# Configuration de pecl derrière un proxy si requis
RUN test -z "${http_proxy}" || pear config-set http_proxy ${http_proxy}

# Installation Package système requis pour les extensions php
# From Trax LRS 3.0 installation guidelines:
# Ctype -> enabled by default in php
# cURL -> require apt libcurl3-dev, then php curl
# DOM -> enabled by default
# Fileinfo -> enabled by default
# Filter -> enabled by default
# Hash -> enabled by default
# Mbstring -> php mbstring
# OpenSSL -> enabled by default
# PCRE -> enabled by default
# PDO (MySQL / PgSQL) -> php pdo_mysql and enable
# Session -> enabled by default
# Tokenizer -> enabled by default
# XML  

RUN apt-get update \
  && apt-get install -y \
    7zip gzip tar unzip xzip\
    cron \
    git \
    libcurl3-dev \
# Reconfiguration de php mbstring
  && docker-php-ext-configure mbstring --enable-mbstring --disable-mbregex \
# Installation des extenstions gérées par pecl
#  && pecl install apcu \
# Installation des extensions gérées par php-ext-install
  && docker-php-ext-install -j$(nproc) \
    curl \
    mbstring \
    pdo_mysql \
# Activation d'extensions php
  && docker-php-ext-enable \
    curl \
    mbstring \
    pdo_mysql \
# Installation manuelle de composer
  && curl -sS https://getcomposer.org/installer | php \
    -- --install-dir=/usr/local/bin --filename=composer

#  Configuration git global et création structures de dossier
RUN git config --global user.email "anonym@mail.com" \
  && git config --global user.name "Anne Onym"

# Récupération trax-lrs
RUN git clone https://github.com/trax-project/trax3-starter-lrs \
  /var/www/trax3

# Changement de répertoire de travail
WORKDIR /var/www/trax3

# Installation via composer de trax
# Changement de droits sur storage and bootstrap/cache
RUN composer install \
  && chown -R www-data:www-data storage bootstrap/cache \
  && chmod -R 0755 storage \
  && chmod -R 0755 bootstrap/cache

# Copie des fichiers de conf apache et trax
COPY trax-apache.conf /etc/apache2/sites-available/trax.conf
COPY trax-php.ini /usr/local/etc/php/php.ini
COPY trax.env /var/www/trax3/.env
COPY start_trax.sh /var/www/trax3/start_trax.sh

# droit exec sur start, desactivation du site par defaut,
# activation du site trax et activation du mode rewrite
RUN a2dissite 000-default.conf \
  && a2ensite trax.conf \
  && a2enmod rewrite \
  && chmod 0555 /var/www/trax3/start_trax.sh

# Nettoyage
RUN rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Déclaration du volumes de données (pour la perf)
VOLUME /var/www/trax3/storage

# Commande de départ: apache2
CMD /var/www/trax3/start_trax.sh


