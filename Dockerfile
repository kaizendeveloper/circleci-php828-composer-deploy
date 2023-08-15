FROM php:8.2.8-cli-alpine3.18
MAINTAINER Miguel Delli Carpini <migueldellicarpini@gmail.com>

RUN addgroup -g 3434 circleci && adduser -u 3434 -G circleci -h /home/circleci -D circleci

RUN apk add --no-cache bzip2-dev icu-dev gettext-dev libxml2-dev libxslt-dev libjpeg-turbo-dev libpng-dev freetype-dev libzip-dev libexif-dev bash curl git rsync \
    && docker-php-ext-install mysqli \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-install bcmath \
    && docker-php-ext-enable bcmath \
    && docker-php-ext-install bz2 \
    && docker-php-ext-enable bz2 \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl \
    && docker-php-ext-install gettext \
    && docker-php-ext-install soap \
    && docker-php-ext-enable soap \
    && docker-php-ext-install xsl \
    && docker-php-ext-enable xsl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-enable gd \
    && docker-php-ext-install zip \
    && docker-php-ext-enable zip \
    && docker-php-ext-install exif \
    && docker-php-ext-enable exif



ENV EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
ENV ACTUAL_CHECKSUM="$(php -r \"echo hash_file('sha384', 'composer-setup.php');\")"

WORKDIR /

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& sh -c "if [ \"$EXPECTED_CHECKSUM\" == \"$ACTUAL_CHECKSUM\" ]; then echo 'COMPOSER OK' ; else set -x && echo \"CORRUPT COMPOSER IMAGE\" && exit 150; fi" \
	&& php composer-setup.php \
	&& echo -e "#!/bin/sh \n/usr/local/bin/php /composer.phar \$@" > /bin/composer && chmod 0755 /bin/composer \
	&& rm composer-setup.php



