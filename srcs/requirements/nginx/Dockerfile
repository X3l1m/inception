FROM debian:bullseye

RUN apt-get update -y && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=NL/ST=North Holland/L=Amsterdam/O=42School/OU=seyildir/CN=seyildir.42.fr" \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]