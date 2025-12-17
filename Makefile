##
# Inception
#
# @file
# @version 0.1

ifneq (,$(wildcard ./srcs/.env))
    include ./srcs/.env
endif

test:
	@echo "test: $(VOLUMES_PATH)"

gen-certificate: 
	@openssl req -x509 -newkey rsa:2048 -sha256 -days 365 -nodes \
		-keyout ./secrets/server.key \
		-out ./srcs/requirements/nginx/tools/server.crt \
		-config ./srcs/requirements/tools/cert.cnf \
		-extensions v3_req
	@echo "------------"
	@echo import certificate into your system from: ./srcs/requirements/nginx/tools/server.crt

gen-passwords:
	@openssl rand -base64 3 > ./secrets/db_root_password.txt 
	@openssl rand -base64 3 > ./secrets/db_user_password.txt 
	@openssl rand -base64 3 > ./secrets/wp_admin_password.txt 
	@openssl rand -base64 3 > ./secrets/wp_user_password.txt 

clean-secrets:
	@rm -rf ./secrets/

prep-gen-secrets:
	@sudo mkdir -p ./secrets/

gen-secrets: sudo clean-secrets prep-gen-secrets gen-passwords gen-certificate

# update /etc/hosts for dns
hosts:

all: up

sudo:
	@sudo -v 

up: sudo
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

fclean:
	@docker compose -f ./srcs/docker-compose.yml down --rmi all --volumes
	@rm -rf /$(VOLUMES_PATH)/*

restart: fclean up
# end
