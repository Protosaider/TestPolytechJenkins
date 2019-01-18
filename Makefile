SHELL=cmd

# include make_env

.PHONY: runall, stopall

# --silent - Don't echo recipes
runall:
	$(MAKE) -C jenkins-master-test run
	$(MAKE) -C nginx-proxy run
	$(MAKE) -C docker-proxy run
	docker run --rm -d -p 5000:5000 --restart=always --name registry registry

stopall:
	$(MAKE) -C jenkins-master-test stop
	$(MAKE) -C nginx-proxy stop
	$(MAKE) -C docker-proxy stop
	docker stop registry
