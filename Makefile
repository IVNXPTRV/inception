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

restart: fclean up
# end
