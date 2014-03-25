#!/bin/bash
set -e

usage() {
  echo -e "
  usage: $0 options

  Configures and starts Storm inside a docker container.

  OPTIONS:
    -h Show this message
    -n Run Nimbus
    -u Run UI
    -s Run Supervisor
    -z list of zookeeper nodes (required)
    "
}

NIMBUS=
UI=
SUPERVISOR=
ZKS=
STORM_VERSION=0.9.1-incubating

while getopts "hnusz:" OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    z)
      ZKS=$OPTARG
      ;;
    n)
      NIMBUS=true
      ;;
    u)
      UI=true
      ;;
    s)
      SUPERVISOR=true
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

if [[ -z $ZKS ]];
then
  usage
  exit 1
fi

IFS=',' read -ra ZK <<< "$ZKS"
for i in "${!ZK[@]}"; do
  echo -e "  - ${ZK[$i]}" >> "/opt/apache-storm-$STORM_VERSION/conf/storm.yaml"
done

cat << EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true

[program:sshd]
command=/usr/sbin/sshd -D
EOF

if [[ $NIMBUS ]];
then
cat << EOF >> /etc/supervisor/conf.d/supervisord.conf
[program:nimbus]
command=/opt/apache-storm-0.9.1-incubating/bin/storm nimbus
EOF
fi

if [[ $UI ]];
then
cat << EOF >> /etc/supervisor/conf.d/supervisord.conf
[program:ui]
command=/opt/apache-storm-0.9.1-incubating/bin/storm ui
EOF
fi

if [[ $SUPERVISOR ]];
then
cat << EOF >> /etc/supervisor/conf.d/supervisord.conf
[program:supervisor]
command=/opt/apache-storm-0.9.1-incubating/bin/storm supervisor
EOF
fi

/usr/bin/supervisord
