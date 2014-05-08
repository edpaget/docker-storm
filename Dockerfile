# DOCKER-VERSION 0.9.0
# VERSION 0.1

FROM ubuntu:12.04
MAINTAINER Edward Paget <ed@zooniverse.org>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update 
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties
RUN add-apt-repository ppa:fkrull/deadsnakes

RUN apt-get update 
RUN apt-get install -y -q openjdk-7-jre-headless python2.6 wget supervisor

RUN mkdir -p /var/log/supervisor

ADD apache-storm-0.9.2-incubating-SNAPSHOT.tar.gz /opt
ADD storm.yaml /opt/apache-storm-0.9.2-incubating-SNAPSHOT/conf/storm.yaml
RUN mkdir -p /opt/storm-data
ADD start_storm.sh /opt/start_storm.sh
RUN chmod u+x /opt/start_storm.sh

EXPOSE 6700 6701 6702 6703 6627 8080

ENTRYPOINT ["./opt/start_storm.sh"]
