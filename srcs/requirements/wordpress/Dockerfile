FROM debian:buster

RUN apt-get update && apt-get install -y \
    php7.3 \
    php7.3-fpm \
    php7.3-mysql \
    php7.3-gd \
    php7.3-mbstring \
    php7.3-xml \
    php7.3-curl \
    curl \
    mariadb-client

# PHP-FPM yapılandırması
RUN mkdir -p /run/php && \
    sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# WordPress indirme ve kurma
WORKDIR /var/www/html
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# WordPress kurulum ve başlatma script'i
COPY tools/wp-config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp-config.sh

EXPOSE 9000

CMD ["/usr/local/bin/wp-config.sh"]
