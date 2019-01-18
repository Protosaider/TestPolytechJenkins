FROM jenkins/jnlp-slave:latest

USER root

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates curl apt-transport-https openssh-client apt-transport-https software-properties-common apt-utils gnupg2

# ENV DOCKER_CHANNEL stable
# ENV DOCKER_VERSION 18.09.0

# RUN set -eux; \
# 	\
# # this "case" statement is generated via "update.sh"
# 	apkArch="$(uname -m)"; \
# 	case "$apkArch" in \
# 		x86_64) dockerArch='x86_64' ;; \
# 		armhf) dockerArch='armel' ;; \
# 		aarch64) dockerArch='aarch64' ;; \
# 		ppc64le) dockerArch='ppc64le' ;; \
# 		s390x) dockerArch='s390x' ;; \
# 		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
# 	esac; \
# 	\
# 	if ! wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
# 		echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
# 		exit 1; \
# 	fi; \
# 	\
# 	tar --extract \
# 		--file docker.tgz \
# 		--strip-components 1 \
# 		--directory /usr/local/bin/ \
# 	; \
# 	rm docker.tgz; \
# 	\
# 	dockerd --version; \
# 	docker --version


RUN apt-get update \
	&& apt-get install -y --no-install-recommends python-pip python

# RUN apt-get update \
# 	# && apt-get install -y --no-install-recommends docker-ce \
# 	&& pip install docker-compose


# RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
#   curl -fsSL https://download.docker.com/linux/static/stable/x86_64/ | apt-key add - && \
#   add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/static $(lsb_release -cs) stable" && \
#   apt-get update && \
#   apt-get install -y docker-ce python python-pip && \

# Install Essentials
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git \
    wget \
    sudo \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# RUN apt-get update
# RUN apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
# RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
# RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# RUN wget -P /tmp/ https://get.docker.com/builds/Linux/x86_64/docker-1.12.6.tgz && \
#     tar -xvf /tmp/docker-1.12.6.tgz --directory /tmp/ && \
#     mv /tmp/docker/docker /usr/local/bin


# # Install Docker from Docker Inc. repositories.
# RUN curl -sSL https://get.docker.com/ | sh
# # Define additional metadata for our image.
# VOLUME /var/lib/docker


ENV DOCKER_USER=docker
ENV DOCKER_GROUP=docker
ARG uid=1000
ARG gid=100

RUN groupadd -g ${gid} ${DOCKER_GROUP} -o 
RUN adduser --uid ${uid} --gid ${gid} ${DOCKER_USER}

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update
RUN apt-get install -y docker-ce


# Define env variables and arguments
ENV JENKINS_HOME=/home/jenkins
ENV JENKINS_USER=jenkins
ARG uid=1001
ARG gid=1001
ARG shell=/bin/sh

# Create Jenkins home directory and create Jenkins group and user
# RUN mkdir -p /home/jenkins && addgroup --gid ${uid} $JENKINS_USER
# Option g is ambiguous (gecos, gid, group)
# group 'jenkins' already exists
# RUN mkdir -p /home/jenkins && addgroup -g ${uid} $JENKINS_USER

RUN mkdir -p /home/jenkins
# RUN adduser -h $JENKINS_HOME -u ${uid} -g ${gid} -G ${JENKINS_USER} -s ${shell} -D ${JENKINS_USER}
RUN adduser -h $JENKINS_HOME -u ${uid} -G ${JENKINS_USER} -s ${shell} -D ${JENKINS_USER}

# Add the jenkins user to sudoers
RUN echo "${JENKINS_USER}    ALL=(ALL)    ALL" >> /etc/sudoers

# Sometimes Docker containers struggled to route or resolve DNS names correctly, so I’ve taken to making sure the proper DNS servers are added to my build slaves.
# Set Name Servers
COPY resolv.conf /etc/resolv.conf

# # Define new truststore location
# ARG trustStore=/etc/ssl/java/truststore
# # Create folder to store new cacerts location
# RUN mkdir -p ${trustStore}
# # Apply permissions
# RUN chown -R $JENKINS_USER $JENKINS_HOME ${trustStore} \
#   && chgrp -R $JENKINS_USER $JENKINS_HOME ${trustStore}

RUN chown -R $JENKINS_USER $JENKINS_HOME ${trustStore}

# RUN chown -R $JENKINS_USER $JENKINS_HOME ${trustStore} \
#   && chgrp -R $JENKINS_USER $JENKINS_HOME ${trustStore}

# Create volume to persist data
# VOLUME /etc/ssl/java/truststore
# 

############################################################################## TEST THIS THING
# RUN sudo usermod -a -G docker jenkins
# RUN groupadd docker

RUN usermod -a -G docker jenkins

# RUN chgrp docker /var/run/docker.sock

# RUN groupmod -g 1001 jenkins
# RUN usermod -u 1001 jenkins

# RUN usermod -g docker jenkins
# RUN usermod -a -G jenkins jenkins


# GCLOUD
ARG CLOUD_SDK_VERSION=229.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

# COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker
RUN apt-get -qqy update && apt-get install -qqy \
        # curl \
        gcc \
        python-dev \
        python-setuptools \
        apt-transport-https \
        lsb-release \
        # openssh-client \
        # git \
        gnupg \
    && easy_install -U pip && \
    pip install -U crcmod   && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y google-cloud-sdk=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-app-engine-python=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-app-engine-python-extras=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-app-engine-java=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-app-engine-go=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-datalab=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-datastore-emulator=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-pubsub-emulator=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-bigtable-emulator=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-cbt=${CLOUD_SDK_VERSION}-0 \
        kubectl && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version && \
    docker --version && kubectl version --client
VOLUME ["/root/.config"]





# Switch to the jenkins user
USER ${JENKINS_USER}