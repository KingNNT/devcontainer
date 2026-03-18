COMPOSE_FILES := -f docker-compose.yml -f docker-compose.override.yml
ifneq (,$(wildcard docker-compose.local.yml))
COMPOSE_FILES += -f docker-compose.local.yml
endif

dev_up:
	docker compose $(COMPOSE_FILES) up -d

dev_down:
	docker compose $(COMPOSE_FILES) down

dev_build:
	docker compose $(COMPOSE_FILES) build

dev_ubuntu_connect:
	docker compose $(COMPOSE_FILES) exec ubuntu bash
