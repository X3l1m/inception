#!/bin/bash

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    # Veri klasörü oluştur ve izinlerini ayarla
    mkdir -p /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
    
    # MariaDB servisini başlat ve veritabanını oluştur
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Geçici SQL dosyası oluştur
    cat << EOF > /tmp/init_db.sql
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
FLUSH PRIVILEGES;
EOF
    
    # MariaDB'yi başlat ve SQL dosyasını çalıştır
    service mysql start
    mysql < /tmp/init_db.sql
    service mysql stop
    
    # Geçici SQL dosyasını sil
    rm /tmp/init_db.sql
fi

# MariaDB'yi çalıştır
exec mysqld_safe
