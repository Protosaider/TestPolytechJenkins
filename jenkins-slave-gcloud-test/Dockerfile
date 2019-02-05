FROM docker:17.12.0-ce as static-docker-source

FROM jenkins/jnlp-slave:latest-jdk11

USER root

ARG CLOUD_SDK_VERSION=228.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

# COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker
RUN apt-get -qqy update && apt-get install -qqy \
        curl \
        gcc \
        python-dev \
        python-setuptools \
        apt-transport-https \
        lsb-release \
        openssh-client \
        git \
        wget \
    	sudo \
        gnupg \
        && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
        python get-pip.py && \
        pip install -U pip && \
        pip install -U crcmod && \
    # RUN easy_install -U pip
    #   python-pip \
    # RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && pip install -U pip
    # && easy_install -U pip && \
    # RUN pip install -U crcmod
    # RUN python /usr/lib/python2.7/dist-packages/easy_install.py pip install -U crcmod
    # pip install -U crcmod   && \
    # RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
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
    # && \
    # sudo usermod -a -G docker jenkins
VOLUME ["/root/.config"]

# Install Essentials
# RUN apt-get update \
	# && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git \
 #    wget \
 #    sudo \
	# && apt-get clean \
	# && rm -rf /var/lib/apt/lists/*
# RUN rm -rf /var/lib/apt/lists/*

# COPY resolv.conf /etc/resolv.conf

# USER jenkins

