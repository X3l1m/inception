FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    apt-get --yes --quiet autoremove --purge && \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/script.sh"]