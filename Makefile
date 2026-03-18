IMAGE_NAME := devcontainer
CONTAINER_NAME := devcontainer

build:
	docker build -t $(IMAGE_NAME) .docker/ubuntu

run:
	docker run -d --name $(CONTAINER_NAME) --restart unless-stopped -v .:/app $(IMAGE_NAME)

exec:
	docker exec -it $(CONTAINER_NAME) bash

stop:
	docker stop $(CONTAINER_NAME) && docker rm $(CONTAINER_NAME)
