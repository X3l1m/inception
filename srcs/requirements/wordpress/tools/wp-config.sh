#!/bin/bash

# Wait for MariaDB to be ready
while ! mariadb -h$WORDPRESS_DB_HOST -u$WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD $WORDPRESS_DB_NAME 2> /dev/null; do
    echo "Waiting for MariaDB to be ready..."
    sleep 5
done

# Download and configure WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
    cd /var/www/html
    wp core download --allow-root
    wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER \
                   --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST \
                   --allow-root
    
    # WordPress installation - using supervisor instead of admin
    wp core install --url=https://$DOMAIN_NAME --title="Inception Project" \
                  --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD \
                  --admin_email=$WP_ADMIN_EMAIL --allow-root
    
    # Update Site URL
    wp option update siteurl https://$DOMAIN_NAME --allow-root
    wp option update home https://$DOMAIN_NAME --allow-root
    
    # Set permalink structure
    wp rewrite structure '/%postname%/' --allow-root
    
    # Make direct URL changes in database
    wp search-replace 'http://localhost' "https://$DOMAIN_NAME" --all-tables --allow-root
    wp search-replace 'https://localhost' "https://$DOMAIN_NAME" --all-tables --allow-root
    
    # Add constant definitions to wp-config.php
    wp config set WP_HOME "https://$DOMAIN_NAME" --allow-root
    wp config set WP_SITEURL "https://$DOMAIN_NAME" --allow-root
    
    # Add a sample page and author
    wp user create author author@$DOMAIN_NAME --role=author --user_pass=author_pwd --allow-root
    wp post create --post_type=page --post_title='About Us' --post_content='This is a sample page created for the Inception project.' --post_status=publish --allow-root
    
    # Set permissions
    chown -R www-data:www-data /var/www/html
fi

# Start PHP-FPM
exec php-fpm7.3 -F
