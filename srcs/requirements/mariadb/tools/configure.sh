#!/bin/env sh

set -e

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# rm -rf /var/lib/mysql/

if [ ! -d "/var/lib/mysql/mysql" ] ||  [ ! -d "/var/lib/mysql/$DB_NAME" ]; then

    # Install the database
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start temporary instance
    mysqld --user=mysql --skip-networking &
    MYSQL_PID=$!

    # Wait a bit for server to start
    sleep 10

    DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
    DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)

    # Setup database and users
    mysql << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

    # Stop temporary instance
    mysqladmin -u root -p${DB_ROOT_PASSWORD} shutdown
    wait $MYSQL_PID
fi
exec "$@"
