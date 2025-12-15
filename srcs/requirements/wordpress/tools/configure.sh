#!/usr/bin/env sh

# wp core download --allow-root --path="/var/www/html"
# wp core is-installed --allow-root --path="/var/www/html" 
# wp config create --allow-root \
#     --dbname="wordpress" \
#     --dbuser="wp_user" \
#     --dbhost="172.17.0.3:3306" \
#     --dbpass="bonamp-tofasi" \
#     --dbcharset="utf8" \
#     --dbcollate="utf8_general_ci" \
#     --path="/var/www/html"
    
# wp core install --allow-root \
#         --url="ipetrov.42.fr" \
#         --title="Inception" \
#         --admin_user="muzzle" \
#         --admin_email="muzzle@m.c" \
#         --admin_password="1234" \
#         --path="/var/www/html/"

# wp user create --allow-root \
#         "$WP_USER_NAME" \
#         "$WP_USER_EMAIL" \
#         --user_pass="$WP_USER_PASSWORD" \
#         --role=author \
#         --path="$WP_PATH"

set -e

WP_PATH="/var/www/html/"

# Download WordPress if the directory is empty
echo "Downloading WordPress if required..."
wp core download --allow-root --path="$WP_PATH"

if wp core is-installed --allow-root --path="$WP_PATH"; then
    echo "WordPress is already installed and ready."
    exec "$@"
fi

echo "Waiting for database connection..."
    while ! nc -z "$DB_HOST" "$DB_PORT"; do
        sleep 1
    done
echo "Database is ready! Starting WordPress configuration."

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)

wp config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbhost="$DB_HOST:$DB_PORT" \
        --dbpass="$DB_USER_PASSWORD" \
        --dbcharset="utf8" \
        --dbcollate="utf8_general_ci" \
        --path="$WP_PATH"

# Install WordPress if it's not installed
echo "Installing WordPress..."
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

wp core install --allow-root \
        --url="$WP_SITE_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_NAME" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --path="$WP_PATH"

wp user create --allow-root \
        "$WP_USER_NAME" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --path="$WP_PATH"

exec "$@"
