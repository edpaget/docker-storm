# DOCKER-VERSION 0.9.0
# VERSION 0.2

FROM ubuntu:12.04
MAINTAINER Edward Paget <ed@zooniverse.org>

RUN apt-get update 
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties
RUN add-apt-repository ppa:fkrull/deadsnakes

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q openjdk-7-jre-headless python2.6 wget supervisor

RUN mkdir -p /var/log/supervisor

RUN mkdir -p /opt/storm-data
ADD start_storm.sh /opt/start_storm.sh
RUN chmod u+x /opt/start_storm.sh
ADD http://mirror.sdunix.com/apache/incubator/storm/apache-storm-0.9.2-incubating/apache-storm-0.9.2-incubating.tar.gz /opt/
RUN tar xf /opt/apache-storm-0.9.2-incubating.tar.gz -C /opt
RUN rm /opt/apache-storm-0.9.2-incubating.tar.gz
ADD storm.yaml /opt/apache-storm-0.9.2-incubating/conf/storm.yaml

EXPOSE 6700 6701 6702 6703 6627 8080

ENTRYPOINT ["./opt/start_storm.sh"]
