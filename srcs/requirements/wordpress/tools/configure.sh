#!/usr/bin/env sh

set -e

WP_PATH="/var/www/html/"

if [ ! -f "$WP_PATH/wp-settings.php" ]; then
    echo "Wordpress core is not found."
    wp core download --allow-root --path="$WP_PATH"
    # replace with wget to make it reliable?
fi

echo "Waiting for database connection..."
    while ! nc -z "$DB_HOST" "$DB_PORT"; do
        sleep 5
    done
echo "Database is ready!"
 
if ! wp core is-installed --allow-root --path="$WP_PATH" 2> /dev/null ; then
    echo "Wordpress core is not installed."

    DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
    WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

    wp config create --allow-root \
            --dbname="$DB_NAME" \
            --dbuser="$DB_USER" \
            --dbhost="$DB_HOST:$DB_PORT" \
            --dbpass="$DB_USER_PASSWORD" \
            --dbcharset="utf8" \
            --dbcollate="utf8_general_ci" \
            --path="$WP_PATH"

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
fi

exec "$@"
