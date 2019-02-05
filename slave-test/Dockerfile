FROM openjdk:8-jre-alpine

USER root


# Add required packages
RUN apk update \
  && apk add --no-cache openssl ca-certificates git shadow docker py-pip \
  && pip install docker-compose


# # Add required packages
# RUN apt-get update \
# 	&& apt-get install -y --no-install-recommends ca-certificates curl apt-transport-https openssh-client apt-transport-https curl software-properties-common apt-utils gnupg2 python-pip python

# # Install Essentials
# RUN apt-get update \
# 	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git \
#     wget \
#     sudo \
# 	&& apt-get clean \
# 	&& rm -rf /var/lib/apt/lists/*


# RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
# RUN add-apt-repository \
#    "deb [arch=amd64] https://download.docker.com/linux/debian \
#    $(lsb_release -cs) \
#    stable"

# RUN apt-get update
# RUN apt-get install -y docker-ce

# Define env variables and arguments
ENV JENKINS_HOME=/home/jenkins
ENV JENKINS_USER=jenkins
ARG uid=1000
ARG shell=/bin/sh

# Create Jenkins home directory and create Jenkins group and user
RUN mkdir -p /home/jenkins \
  && addgroup -g ${uid} $JENKINS_USER \
  && adduser -h $JENKINS_HOME -u ${uid} -G ${JENKINS_USER} -s ${shell} -D ${JENKINS_USER}

# Add the jenkins user to sudoers
RUN echo "${JENKINS_USER}    ALL=(ALL)    ALL" >> /etc/sudoers

# Set name servers
COPY resolv.conf /etc/resolv.conf

# Define new truststore location
ARG trustStore=/etc/ssl/java/truststore

# Create folder to store new cacerts location
RUN mkdir -p ${trustStore}

# Apply permissions
RUN chown -R $JENKINS_USER $JENKINS_HOME ${trustStore} \
  && chgrp -R $JENKINS_USER $JENKINS_HOME ${trustStore}

# Create volume to persist data
VOLUME /etc/ssl/java/truststore

# RUN chgrp docker /var/run/docker.sock
# RUN adduser docker sudo
RUN usermod -a -G docker jenkins

# RUN adduser jenkins sudo

RUN groupmod -g 1000 jenkins
RUN usermod -u 1000 jenkins

RUN groupmod -g 1001 docker
# RUN usermod -u 1000 jenkins

# Switch to the jenkins user
USER ${JENKINS_USER}
