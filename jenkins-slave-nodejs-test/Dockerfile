FROM jenkins/jnlp-slave:latest-jdk11

# Install Essentials
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git \
    wget \
    sudo \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# groupadd: group 'jenkins' already exists
# The command '/bin/sh -c groupadd -g ${gid} ${group}     && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}' returned a non-zero code: 9
# ARG user=jenkins
# ARG group=jenkins
# ARG uid=1000
# ARG gid=1000
# ENV JENKINS_HOME /home/${user}
# # Jenkins is run with user `jenkins`, uid = 1000
# RUN groupadd -g ${gid} ${group} \
#     && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}
# RUN chown -R ${user}:${user} /home/${user}
# # Add the jenkins user to sudoers
# RUN echo "${user}    ALL=(ALL)    ALL" >> etc/sudoers

# Sometimes Docker containers struggled to route or resolve DNS names correctly, so I’ve taken to making sure the proper DNS servers are added to my build slaves.
# Set Name Servers
COPY resolv.conf /etc/resolv.conf

