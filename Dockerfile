FROM phusion/baseimage:0.9.15

MAINTAINER Shu Sugimoto "shu@su.gimo.to"

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# service command should not do anything
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/service

RUN curl -L http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key | apt-key add -
RUN sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list"

# apt-get update
RUN apt-get update

# install postgresql
RUN apt-get -y --no-install-recommends install postgresql-9.3=9.3.5-0ubuntu0.14.04.1
RUN apt-get -y --no-install-recommends install pwgen

# install owncloud
RUN apt-get -y --no-install-recommends install owncloud=7.0.3-1

# cleanup apt cache
RUN apt-get clean all
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# apache
RUN a2enmod ssl
RUN a2ensite default-ssl

# database
#RUN sudo -u postgres psql -c "create role www-data"
#RUN sudo -u postgres psql -c "create database owncloud owner www-data"

RUN mkdir /etc/service/postgresql
ADD service/postgresql.run /etc/service/postgresql/run

RUN mkdir /etc/service/apache2
ADD service/apache2.run /etc/service/apache2/run

RUN chmod +x /etc/service/apache2/run
RUN chmod +x /etc/service/postgresql/run

EXPOSE 80
EXPOSE 443

CMD ["/sbin/my_init"]
