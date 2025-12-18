# Developer Documentation

This document guides developers on setting up, building, and managing the Inception project from scratch.

## Environment Setup
1. **Prerequisites**:
   - Fresh Debian VM (e.g., Bookworm).
   - Install Docker: Follow official docs (apt repo method: add key, repo, install docker-ce docker-compose-plugin).
   - Install Make: `sudo apt install make`.
   - Clone repo: `git clone <repo> && cd inception`.

2. **Configuration Files**:
   - `.env` in `./srcs/`: Fill non-sensitive vars (e.g., DOMAIN_NAME=ipetrov.42.fr, DB_NAME=wordpress).
   - Secrets: Run `make gen-secrets`. Adjust generated credentials if need in `./secrets/*` Never commit (see .gitignore).
   - Hosts: Run `make add-domain-name` to add "127.0.0.1 ipetrov.42.fr" to `/etc/hosts`.

3. **Secrets**: Docker secrets are used for all credentials. Files in ./srcs/secrets/ are mounted via docker-compose.yml and read in scripts (e.g., export DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)). For dev, modify with `echo -n "pw" > ./srcs/secrets/<file>`.

## Building and Launching
- **Full Build**: `make all` – Builds images, generate new secrets, add domain to hosts, starts stack.
- **Quick Start**: `make up` – Starts from existing images.
- **Makefile Targets**:
  - `make down`: Stop containers.
  - `make re`: Down + full rebuild.
  - `make clean`: Down + remove images (--rmi all).
  - `make fclean`: Clean + remove volumes (-v).
  - `make ps`: List containers.
  - `make logs`: Tail logs from services.

## Managing Containers and Volumes
- **Commands**:
  - Inspect: `docker inspect <container>` (e.g., wordpress).
  - Exec: `docker exec -it mariadb mysql -u root -p` (DB shell – PW from ./secrets/db_root_password).
  - Volumes: Persistent in `~/data/` (bind mounts). List: `docker volume ls`.
- **Data Persistence**: DB data in `~/data/db`, WP files in `~/data/wordpress` – survives restarts, but fclean deletes.

## Project Data Storage
- **Containers**: Ephemeral (recreated on build).
- **Volumes**: Bind mounts to host for persistence (edit files directly on host).
- **Logs**: In containers (view with `make logs`); no persistent logs configured.

For user guide, see USER_DOC.md.
