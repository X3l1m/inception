#!/bin/bash

echo "Nginx is starting..."

# Nginx'in yapılandırmasını test et
nginx -t
if [ $? -eq 0 ]; then
    echo "Nginx configuration is valid."
else
    echo "Nginx configuration is invalid. Exiting..."
    exit 1
fi

# Nginx'i başlat
echo "Nginx has been successfully started!"
exec nginx -g "daemon off;"