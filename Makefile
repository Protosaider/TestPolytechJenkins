SHELL=cmd

# include make_env

.PHONY: runall, stopall, pull, run

# --silent - Don't echo recipes
runall:
	$(MAKE) -C jenkins-master run
	$(MAKE) -C nginx-proxy run
	$(MAKE) -C docker-proxy run
	docker run -d -p 5000:5000 --restart=always --name registry registry

pull:
	docker pull localhost:5000/react-app

run:
	docker run -d -p 3000:3000 --name react localhost:5000/react-app:latest

stopall:
	$(MAKE) -C jenkins-master stop
	$(MAKE) -C nginx-proxy stop
	$(MAKE) -C docker-proxy stop
	docker stop registry && docker rm registry 
	docker stop react && docker rm react
