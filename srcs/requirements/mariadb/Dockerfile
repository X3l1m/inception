FROM debian:buster

RUN apt-get update && apt-get install -y mariadb-server

# MariaDB yapılandırma
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    sed -i 's/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# MariaDB kurulum script'i
COPY tools/init_db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_db.sh

EXPOSE 3306

CMD ["/usr/local/bin/init_db.sh"]
