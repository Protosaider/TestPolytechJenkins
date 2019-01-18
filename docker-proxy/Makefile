SHELL=cmd

CONTAINER_NAME = docker-proxy
NETWORK = jenkins-net
TAG = latest
#docker run -p 8000:80 --name=$(CONTAINER_NAME) --network $(NETWORK) -d $(CONTAINER_NAME):$(TAG)

build:
	docker build -t $(CONTAINER_NAME):$(TAG) -f Dockerfile .

run:
	docker run --name=$(CONTAINER_NAME) --volume /var/run/docker.sock:/var/run/docker.sock --network $(NETWORK) --network-alias proxy1 -d $(CONTAINER_NAME):$(TAG)

stop:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)