FROM debian:bullseye

RUN apt-get update -y && apt-get install -y nginx openssl

# SSL sertifikası oluşturma
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=TR/ST=Istanbul/L=Istanbul/O=42School/OU=seyildir/CN=seyildir.42.fr" \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

# Nginx yapılandırmasını kopyalama
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Nginx daemon modu kapatma
RUN sed -i 's/^pid/daemon off;\npid/' /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx"]
