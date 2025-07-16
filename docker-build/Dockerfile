FROM php:8.4.10-fpm-alpine3.21

RUN apk add --no-cache \
        freetype \
        libjpeg-turbo \
        libpng \
        oniguruma \
        \
        freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
        oniguruma-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd mbstring mysqli \
    && apk del \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        oniguruma-dev

ADD tar_extensions.sh /

RUN /tar_extensions.sh
