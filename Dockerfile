ARG JENKINS_VER=lts
# ARG JENKINS_REGISTRY=jenkins/jenkins
ARG JENKINS_NS=jenkins
ARG JENKINS_REPO=jenkins

#FROM ${JENKINS_REGISTRY}:${JENKINS_VER}
FROM ${JENKINS_NS}/${JENKINS_REPO}:${JENKINS_VER}
# ns - your docker namespace; repo - your docker repo name

# LABEL mainteiner="workinghandguard@gmail.com" Fedor Ermolchev

#ENV JAVA_OPTS="-Xmx8192m"
#ENV JENKINS_OPTS=" --handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log --httpsPort=8080 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pk"
ENV JENKINS_OPTS=" --logfile=/var/log/jenkins/jenkins.log --httpPort=8080"

USER root

##### # SETTING UP A LOG FOLDER
#####USER root
RUN mkdir /var/log/jenkins
RUN chown -R  jenkins:jenkins /var/log/jenkins
#####USER jenkins
#####WORKDIR /settings

RUN apt-get update \
	### && apt-get install -y --no-install-recommends apt-transport-https \ 
	# apt-transport-https - позволяет обращаться к APT-репозиториям через протокол https
	# Use debian_frontend - because jenkins:lts image based on DEBIAN
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-transport-https \
	# files of CA certificates to allow SSL-based applications to check for the authenticity of SSL connections.
	ca-certificates \
	# tool for transferring data using various protocols (URL, connecting with servers FTP, HTTP, etc.)
    curl \
    # инструмент GNU для безопасной коммуникации и хранения данных. Он может использоваться для зашифровки данных и создания цифровых подписей. 
    gnupg2 \
	# This software provides an abstraction of the used apt repositories. It allows you to easily manage your distribution and independent software vendor software sources.
    software-properties-common \
    # For make command and makefiles
    build-essential \
    #vim \
    # wget \
	# && curl -sSL https://get.docker.com/ | sh \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*


# 	# install gosu for a better su+exec command
# ARG GOSU_VERSION=1.10
# RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
#  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
#  && chmod +x /usr/local/bin/gosu \
#  && gosu nobody true 


# install docker cli only
# 
ARG DOCKER_CLI_VERSION==5:18.09.0~3-0~debian-stretch

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
 && add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable" \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    docker-ce-cli${DOCKER_CLI_VERSION} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd -r docker \
 && usermod -aG docker jenkins

# install all
# 
#     curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
#     add-apt-repository \
#        "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
#        $(lsb_release -cs) \
#        stable" && \
#  #Install docker-ce
#     apt-get update && \
#     apt-get -y install docker-ce && \
#     rm -rf /var/lib/apt/lists/* && \
#  #Install docker compose
#     curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
#  #Apply executable permissions to the binary
#     chmod +x /usr/local/bin/docker-compose && \
#     usermod -aG docker jenkins
# USER jenkins

# ## INSTALL PLUGINS.SSH
# # it is possible to pass a file that contains this set of plugins (with or without line breaks)
# COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
#
# #run the script manually in Dockerfile
# RUN /usr/local/bin/install-plugins.sh docker-slaves github-branch-source:1.8

USER jenkins

HEALTHCHECK \
			#--interval=5s \
            #--timeout=5s \
            CMD curl -sSLf http://localhost:8080/login >/dev/null || exit 1

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION=0

LABEL \
# This label contains the Date/Time the image was built. The value SHOULD be formatted according to RFC 3339.
    org.label-schema.build-date=$BUILD_DATE \
#How to run a container based on the image under the Docker runtime.
    org.label-schema.docker.cmd="docker run -d -p 8080:8080 -v \"$$(pwd)/jenkins-home:/var/jenkins_home\" -v /var/run/docker.sock:/var/run/docker.sock workinghandguard/jenkins-docker" \
#Text description of the image. May contain up to 300 characters.
    org.label-schema.description="Jenkins with docker support, Jenkins ${JENKINS_VER}, Docker ${DOCKER_VER}" \
#A human friendly name for the image. For example, this could be the name of a microservice in a microservice architecture.
    org.label-schema.name="workinghandguard/jenkins-docker" \
#This label SHOULD be present to indicate the version of Label Schema in use.
    org.label-schema.schema-version="1.0" \
#URL of website with more information about the product or service provided by the container.
    org.label-schema.url="https://github.com/Protosaider/" \
#Identifier for the version of the source code from which this image was built. For example if the version control system is git this is the SHA.
    org.label-schema.vcs-ref=$VCS_REF \
#URL for the source code under version control from which this container image was built.
    org.label-schema.vcs-url="https://github.com/Protosaider/" \
#The organization that produces this image.
    org.label-schema.vendor="Fedor Ermolchev" \
#Release identifier for the contents of the image. This is entirely up to the user and could be a numeric version number like 1.2.3, or a text label.
#You SHOULD omit the version label, or use a marker like “dirty” or “test” to indicate when a container image does not match a labelled / tagged version of the code.
    org.label-schema.version="${JENKINS_NS}/${JENKINS_REPO}:${JENKINS_VER}-${VERSION}"

## entrypoint is used to update docker gid and revert back to jenkins user
# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]
# HEALTHCHECK CMD curl -sSLf http://localhost:8080/login >/dev/null || exit 1
# 
# ARG BUILD_DATE
# ARG VCS_REF
# ARG IMAGE_PATCH_VER=0
# LABEL \
#     org.label-schema.build-date=$BUILD_DATE \
#     org.label-schema.docker.cmd="docker run -d -p 8080:8080 -v \"$$(pwd)/jenkins-home:/var/jenkins_home\" -v /var/run/docker.sock:/var/run/docker.sock bmitch3020/jenkins-docker" \
#     org.label-schema.description="Jenkins with docker support, Jenkins ${JENKINS_VER}, Docker ${DOCKER_VER}" \
#     org.label-schema.name="bmitch3020/jenkins-docker" \
#     org.label-schema.schema-version="1.0" \
#     org.label-schema.url="https://github.com/sudo-bmitch/jenkins-docker" \
#     org.label-schema.vcs-ref=$VCS_REF \
#     org.label-schema.vcs-url="https://github.com/sudo-bmitch/jenkins-docker" \
#     org.label-schema.vendor="Brandon Mitchell" \
#     org.label-schema.version="${JENKINS_VER}-${IMAGE_PATCH_VER}"

# ????????
# 
# COPY Jenkinsfile /program/Jenkinsfile
# ADD ./nginx.conf /etc/nginx/
# (путь указывается относительно папки в которой находится dockerfile)