FROM jenkins/inbound-agent:latest-jdk11

RUN apt update && apt upgrade

RUN apt install unzip

USER jenkins
