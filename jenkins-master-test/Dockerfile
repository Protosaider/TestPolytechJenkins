FROM debian:stretch

ENV LANG C.UTF-8
# ENV JAVA_VERSION 8u162
# ENV JAVA_DEBIAN_VERSION 8u162-b12-1~deb9u1

# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    wget \
    curl \
    ca-certificates \
    zip \
    openssh-client \
    unzip \
    openjdk-8-jdk \
    ca-certificates-java \
    git \
    && rm -rf /var/lib/apt/lists/*


RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

ARG user=jenkins
ARG group=jenkins
ARG uid=1001
ARG gid=1001
ARG http_port=8080
ARG agent_port=50000
# ARG JENKINS_VERSION=2.112
ARG JENKINS_VERSION=2.157
# ARG JENKINS_VERSION=latest
# ARG TINI_VERSION=v0.17.0
ARG TINI_VERSION=v0.18.0

# jenkins.war checksum, download will be validated using it
# ARG JENKINS_SHA=085f597edeb0d49d54d7653f3742ba31ed72b8a1a2b053d2eb23fd806c6a5393
ARG JENKINS_SHA=8b03ec1c74325df030c65d4f5347191efb9f3a6ee84a27fb3050a18513d937b6

# Can be used to customize where jenkins.war get downloaded from
# ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war
ARG JENKINS_URL=http://mirrors.jenkins.io/war/${JENKINS_VERSION}/jenkins.war

ENV JENKINS_VERSION ${JENKINS_VERSION}
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JAVA_OPTS="-Xmx8192m -Djenkins.install.runSetupWizard=false"
ENV JENKINS_OPTS="--handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log  --webroot=/var/cache/jenkins/war"
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

# Use tini as subreaper in Docker container to adopt zombie processes
RUN curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture) -o /sbin/tini \
  && chmod +x /sbin/tini

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R ${user}:${user} /var/log/jenkins
RUN chown -R ${user}:${user} /var/cache/jenkins

# for main web and slave agents:
EXPOSE ${http_port}
EXPOSE ${agent_port}

# Copy in local config files
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
COPY jenkins-support /usr/local/bin/jenkins-support
COPY plugins.sh /usr/local/bin/plugins.sh
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
RUN chmod +x /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy \
    && chmod +x /usr/local/bin/jenkins-support \
    && chmod +x /usr/local/bin/plugins.sh \
    && chmod +x /usr/local/bin/jenkins.sh \
    && chmod +x /usr/local/bin/install-plugins.sh

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# RUN groupadd -g 102 docker \
#     && useradd -u 1000 -g 102 docker


USER ${user}


ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION=0

LABEL \
# This label contains the Date/Time the image was built. The value SHOULD be formatted according to RFC 3339.
    org.label-schema.build-date=$BUILD_DATE \
#How to run a container based on the image under the Docker runtime.
    org.label-schema.docker.cmd="docker run -d -p 8080:8080 -v \"$$(pwd)/jenkins-home:/var/jenkins_home\" -v /var/run/docker.sock:/var/run/docker.sock workinghandguard/jenkins" \
#Text description of the image. May contain up to 300 characters.
    org.label-schema.description="Jenkins with docker support, Jenkins ${JENKINS_VER}, Docker ${DOCKER_VER}" \
#A human friendly name for the image. For example, this could be the name of a microservice in a microservice architecture.
    org.label-schema.name="workinghandguard/jenkins" \
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


ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]

