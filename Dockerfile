FROM sjoerdmulder/java8

RUN apt-get update && apt-get install -y unzip iptables lxc build-essential fontconfig apt-transport-https git-core

# This will use the 1.6.0 release
RUN echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get update && apt-get install -y lxc-docker-1.6.0 && rm -rf /var/lib/apt/lists/*
ADD 10_wrapdocker.sh /etc/my_init.d/10_wrapdocker.sh

ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
ENV AGENT_DIR  /opt/buildAgent

# Check install and environment
ADD 00_checkinstall.sh /etc/my_init.d/00_checkinstall.sh

RUN adduser --disabled-password --gecos "" teamcity
RUN sed -i -e "s/%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/" /etc/sudoers
RUN usermod -a -G docker,sudo teamcity
RUN mkdir -p /data

RUN curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

EXPOSE 9090

VOLUME /var/lib/docker
VOLUME /data

ADD service /etc/service
