.PHONY: dev-setup env up down restart reload sh mysql mysql-x php-x nginx-x sofiles

COMPOSE=docker compose
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

dev-setup: env sofiles
	

env:
	test -f .env || cp .env.example .env

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down --remove-orphans

restart: down up
	

reload:
	$(COMPOSE) exec php   killall -USR1 php-fpm
	$(COMPOSE) exec nginx killall -USR1 nginx

sh:
	$(COMPOSE) exec php ash

mysql:
	$(COMPOSE) exec mysql bash

mysql-x:
	$(COMPOSE) exec -T mysql $(ARGS)

php-x:
	$(COMPOSE) exec -T php $(ARGS)

nginx-x:
	$(COMPOSE) exec -T nginx $(ARGS)

sofiles:
	./develop/sofiles_create.sh

