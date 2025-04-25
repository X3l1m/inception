FROM debian:buster

RUN apt-get update && apt-get install -y nginx openssl

# SSL sertifikası oluştur
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=TR/ST=Istanbul/L=Istanbul/O=42School/OU=42/CN=seyildir.42.fr"

# NGINX yapılandırmasını kopyala
COPY conf/nginx.conf /etc/nginx/sites-available/default

# NGINX'i başlat
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 443
