FROM jenkins/inbound-agent:alpine as jnlp

FROM jenkins/agent:latest-jdk17

ARG version
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="$version"

ARG user=jenkins

USER root

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent

RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

RUN apt-get update \
  && apt-get -y install \
    software-properties-common

RUN apt-get update \
  && apt-get -y install \
    unzip \
    curl \
    rsync \
    openssh-client
    
RUN apt install apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common -y
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN apt update
RUN apt install adoptopenjdk-11-hotspot -y
RUN which java

USER ${user}

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
