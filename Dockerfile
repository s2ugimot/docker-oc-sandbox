FROM phusion/baseimage:0.9.15

MAINTAINER Shu Sugimoto "shu@su.gimo.to"

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# service command should not do anything
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/service

RUN curl -L http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key | apt-key add -
RUN sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list"

RUN apt-get update
RUN apt-get --assume-yes install owncloud --no-install-recommends

# cleanup apt cache
RUN apt-get clean all
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*


RUN mkdir /etc/service/apache2
ADD service/apache2.run /etc/service/apache2/run

RUN chmod +x /etc/service/apache2/run

CMD ["/sbin/my_init"]
