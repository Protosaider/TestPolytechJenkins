FROM buildpack-deps:stretch-scm

# Socat is a simple linux utility for transporting data between two byte streams. 
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends socat \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# We’re making a simple docker image to put our docker.sock from our desktop on one end and TCP port 2375 on the other. 
# This is why the docker images is mounting a volume that contains the socket file, bridging desktop with docker network.

VOLUME /var/run/docker.sock

# The goal here is to take your docker.sock file and expose it on port 2375 securely and only to Jenkins. 
# We need to do this because the Jenkins Docker plugin expects to talk over TCP/IP or HTTP to a port. 
# In a production environment this would be some kind of Docker Swarm end point, but here on our local setup it’s just your desktop.
# 
# We don’t want to expose that port on your desktop to your network. So once we have an image, we’re going to have it join our docker-network for Jenkins where it can keep that port private.
# 
# docker tcp port
EXPOSE 2375
# or 2376? 

# Listens on <port> [TCP service] and accepts a TCP/IP connection. The IP version is 4 or the one specified with address option pf, socat option (-4, -6), 
# or environment variable SOCAT_DEFAULT_LISTEN_IP. Note that opening this address usually blocks until a client connects.
# 
# из-за reuseaddr, он обеспечивает немедленный перезапуск после завершения мастер-процесса, даже если некоторые дочерние сокеты не полностью закрыты
# Allows other sockets to bind to an address even if parts of it (e.g. the local port) are already in use by socat
# 
# After establishing a connection, handles its channel in a child process and keeps the parent process attempting to produce more connections, 
# either by listening or by connecting in a loop (example).
# 
# Communicates with the specified peer socket, defined by [<filename>] assuming it is a UNIX domain socket. It first tries to connect and, if that fails, assumes it is a datagram socket, thus supporting both types.
# 
# the Docker daemon listens on the /var/run/docker.sock unix socket by default:  -H unix:///var/run/docker.sock
# 
ENTRYPOINT ["socat", "TCP-LISTEN:2375,reuseaddr,fork", "UNIX-CLIENT:/var/run/docker.sock"]
# ENTRYPOINT ["socat", "TCP-LISTEN:2375,reuseaddr,fork UNIX-CLIENT:/var/run/docker.sock"]