FROM debian:bullseye

RUN apt-get update -y && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-soap \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-zip \
    wget \
    mariadb-client \
    sendmail

# PHP-FPM yapılandırması
RUN mkdir -p /run/php && \
    sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# WordPress indirme ve kurulum
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    cp -a wordpress/. . && \
    rm -rf wordpress latest.tar.gz

# wp-cli kurulumu
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Başlangıç scriptini kopyalama
COPY ./tools/script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/script.sh"]
