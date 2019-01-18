SHELL=cmd

CONTAINER_NAME = jenkins-nginx
NETWORK = jenkins-net
TAG = latest
#docker run -p 8000:80 --name=$(CONTAINER_NAME) --network $(NETWORK) -d $(CONTAINER_NAME):$(TAG)

build:
	docker build -t $(CONTAINER_NAME):$(TAG) -f Dockerfile .

run:
	docker run -p 80:80 --name=$(CONTAINER_NAME) --network $(NETWORK) -d $(CONTAINER_NAME):$(TAG)
# docker run -p 8000:80 --name=$(CONTAINER_NAME) --network $(NETWORK) -d $(CONTAINER_NAME):$(TAG)

stop:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)