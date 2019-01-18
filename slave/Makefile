SHELL=cmd

CONTAINER_NAME = slave
TAG = latest

build:
	docker build -t $(CONTAINER_NAME):$(TAG) -f Dockerfile .

run:
	docker run --name=$(CONTAINER_NAME) -it $(CONTAINER_NAME):$(TAG)
# docker run --name=$(CONTAINER_NAME) -d $(CONTAINER_NAME):$(TAG)
# docker run --name=$(CONTAINER_NAME) -d $(CONTAINER_NAME):$(TAG) bash

stop:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)