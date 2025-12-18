##
# Inception
#
# @file
# @version 0.1

ifneq (,$(wildcard ./srcs/.env))
    include ./srcs/.env
endif

gen-certificate: 
	@openssl req -x509 -newkey rsa:2048 -sha256 -days 365 -nodes \
		-keyout ./secrets/server.key \
		-out ./srcs/requirements/nginx/tools/server.crt \
		-config ./srcs/requirements/tools/cert.cnf \
		-extensions v3_req 2> /dev/null
	@echo import certificate into your system from: ./srcs/requirements/nginx/tools/server.crt
	@echo "Trying to add certificate to Local Trust Store.."
	@(cat ./srcs/requirements/nginx/tools/server.crt | sudo tee -a /etc/ssl/certs/ca-certificates.crt > /dev/null) || true

gen-passwords:
	@openssl rand -base64 3 > ./secrets/db_root_password.txt 
	@openssl rand -base64 3 > ./secrets/db_user_password.txt 
	@openssl rand -base64 3 > ./secrets/wp_admin_password.txt 
	@openssl rand -base64 3 > ./secrets/wp_user_password.txt 

clean-secrets:
	@rm -rf ./secrets/*

prep-gen-secrets:
	@echo "Generating new secrets..."
	@mkdir -p ./secrets/

gen-secrets: sudo prep-gen-secrets clean-secrets gen-passwords gen-certificate

add-domain-name: sudo
	@grep -q "${DOMAIN_NAME}" /etc/hosts || (echo "127.0.0.1 ${DOMAIN_NAME}" | sudo tee -a /etc/hosts > /dev/null) || true

all: gen-secrets re

sudo:
	@sudo -v 

up: sudo add-domain-name
	@sudo mkdir -p /$(VOLUMES_PATH)/mariadb
	@sudo mkdir -p /$(VOLUMES_PATH)/wordpress
	@sudo chmod 755 /$(VOLUMES_PATH)/mariadb
	@sudo chmod 755 /$(VOLUMES_PATH)/wordpress
	@docker compose -f ./srcs/docker-compose.yml up -d --build --wait
	@echo
	@echo "Services running at https://$(DOMAIN_NAME)"

down:
	@docker compose -f ./srcs/docker-compose.yml down

clean:
	@docker compose -f ./srcs/docker-compose.yml down --rmi all 

fclean: sudo
	@docker compose -f ./srcs/docker-compose.yml down --rmi all --volumes
	@sudo rm -rf /$(VOLUMES_PATH)/*
	@echo "Removing ${DOMAIN_NAME} from /etc/hosts..."
	@sudo sed -i "/${DOMAIN_NAME}/d" /etc/hosts

ps:
	@docker compose -f ./srcs/docker-compose.yml ps -a

logs:
	@docker logs mariadb --tail 20
	@docker logs wordpress --tail 20
	@docker logs nginx --tail 20

re: fclean up

.PHONY: all up down fclean clean logs re gen-secrets
