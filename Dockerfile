################################################################################
# mesos-slave:1.3.0
# Date: 02/20/2017
# Docker Version: 1.12.1-0~trusty
# Mesos Version: 1.1.0-2.0.107.ubuntu1404
#
# Description:
# Mesos slave container with docker-engine installed. With Docker moving away
# from a monolithic binary, docker-engine must now be installed within the
# container itself.
# Former author
# MAINTAINER Bob Killen / killen.bob@gmail.com / @mrbobbytables
################################################################################

FROM pixelfederation/mesos-base:1.3.0

MAINTAINER Milan Baran / mbaran@pixelfederation.com / @mbaran


ENV VERSION_DOCKER=1.12.6-0~ubuntu-trusty
ENV DOCKER_LOGIN_ENABLED=false
ENV SERVICE_DOCKER_SOCKET_PROXY=disabled

RUN apt-get update                           \
 && apt-get -y install apt-transport-https ca-certificates   \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2C52609D  \
 && echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get purge lxc-docker \
 && apt-cache policy docker-engine=$VERSION_DOCKER \
 && apt-get update \
# && apt-get -y install linux-image-extra-$(uname -r) apparmor \
# && apt-get -y install linux-image-generic-lts-trusty \
 && apt-get -y install socat docker-engine=$VERSION_DOCKER \
#    echo "DOCKER_OPTS=$DOCKER_OPTS --insecure-registry=DOCKER_REGISTRY_HOST" >> /etc/default/docker && \
 && apt-get -y autoremove          \
 && apt-get -y autoclean           \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

COPY ./skel /

ENV DOCKER_API_VERSION=1.23

RUN chmod +x ./init.sh  \
 && chmod +x ./usr/local/sbin/docker  \
 && chown -R logstash-forwarder:logstash-forwarder /opt/logstash-forwarder

EXPOSE 5051

 CMD ["./init.sh"]
