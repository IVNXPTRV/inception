# User Documentation

This document is for end users or administrators to manage the Inception WordPress stack.

## Services Provided
The stack deploys a secure WordPress site with:

- **Nginx**: Reverse proxy on HTTPS (Port 443, TLS only – no HTTP).
- **WordPress**: Dynamic CMS with PHP-FPM (two users: admin "muzzle" and author "essint").
- **MariaDB**: Backend database for WordPress (persistent data).

The site is accessible at https://ipetrov.42.fr (self-signed cert – accept warning, if required).

## Starting and Stopping
- **Start**: Run `make all`(generates new secrets) or `make up` for quick start.
- **Stop**: Run `make down`.
- **Check Status**: `make ps` (lists containers) or `docker ps`.

## Accessing the Website
- **Frontend**: https://ipetrov.42.fr – Browse/create posts.
- **Admin Panel**: https://ipetrov.42.fr/wp-admin – Manage site.
  - Users: Admin (full access), Author (posts only).
- **From CLI**: Use `curl -k https://ipetrov.42.fr` for CLI test (ignores SSL).

## Managing Credentials
- Credentials are managed via Docker Secrets in `./srcs/secrets/` (e.g., wp_admin_password file).
- Change passwords: Edit secret files (e.g., `echo -n "newpw" > ./srcs/secrets/wp_admin_password.txt`), then `make re`.
- Database: Root WP in `./secrets/db_user_password`, WP DB user "wp_user" (DB_USER from .env).
- Non-sensitive vars (e.g., DOMAIN_NAME) in `./srcs/.env` – edit and restart.

## Checking Services
- **Logs**: `make logs` – Last 20 lines from each container (mariadb, wordpress, nginx).
- **Health**: `make ps` – All should be "Up".
- **Data Location**: Persistent in `/home/ipetrov/data/` (mariadb/ for MariaDB, wordpress/ for WP files).
- **Troubleshoot**: If 502 error, check logs for PHP-FPM/DB connection issues.

For developer setup, see DEV_DOC.md.
