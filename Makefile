IMAGE_NAME := devcontainer
CONTAINER_NAME := devcontainer

build:
	docker build -t $(IMAGE_NAME) .docker/ubuntu

WORKSPACE_DIR := ~/Documents/workspaces

run:
	docker run -d --name $(CONTAINER_NAME) --restart unless-stopped --network host -v .:/app $(IMAGE_NAME)

run-workspace:
	docker run -d --name $(CONTAINER_NAME) --restart unless-stopped --network host -v $(WORKSPACE_DIR):/app $(IMAGE_NAME)

exec:
	docker exec -it $(CONTAINER_NAME) bash

stop:
	docker stop $(CONTAINER_NAME) && docker rm $(CONTAINER_NAME)
