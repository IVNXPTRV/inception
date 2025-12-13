#!/usr/bin/env sh

set -e

if [ -f ./wp-config.php ]; then
	echo "wordpress already configured"
    exec "$@"
fi
    
DB_PASSWORD=$(cat /run/secrets/db_password.txt)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password.txt)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password.txt)

# connect to db
# sed -i "s/database_name_here/$DB_NAME/" wp-config.php 
# sed -i "s/username_here/$DB_USER/" wp-config.php 
# sed -i "s/password_here/$DB_PASSWORD/" wp-config.php 
# sed -i "s/localhost/$DB_HOST/" wp-config.php
wp config create --allow-root \
    --dbname=${DB_NAME} \
    --dbuser=${DB_USER} \
    --dbhost=${DB_HOST} \
    --dbpass=${DB_PASSWORD} \
    --dbcharset="utf8" \
    --dbcollate="utf8_general_ci" \
    --path='/var/www/html'

# install wordpress core
wp core install \
        --url="$WP_SITE_URL" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_NAME" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --allow-root

# create additional user
wp user create \
        "$WP_USER_NAME" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root

exec "$@"
