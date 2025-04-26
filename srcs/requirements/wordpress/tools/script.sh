#!/bin/bash

# MariaDB'nin çalışmasını bekle
while ! mariadb -h mariadb -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE &>/dev/null; do
    echo "MariaDB connecting..."
    sleep 3
done
echo "MariaDB connection established!"

# wp-config.php oluşturma
if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --path=/var/www/html

    # WordPress kurulumu
    wp core install --allow-root \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path=/var/www/html

    # İkinci kullanıcıyı ekle
    wp user create $WP_USER $WP_USER_EMAIL \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --allow-root \
        --path=/var/www/html
fi

# PHP-FPM başlatma
exec php-fpm7.4 -F