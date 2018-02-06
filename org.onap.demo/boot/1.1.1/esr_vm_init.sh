#!/bin/bash

NEXUS_USERNAME=$(cat /opt/config/nexus_username.txt)
NEXUS_PASSWD=$(cat /opt/config/nexus_password.txt)
NEXUS_DOCKER_REPO=$(cat /opt/config/nexus_docker_repo.txt)
DOCKER_IMAGE_VERSION=$(cat /opt/config/esr_docker.txt)

source /opt/config/onap_ips.txt

# start up esr
# add registry and dns configurations to docker daemon
# author mlli5886
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://registry.docker-cn.com"],
  "insecure-registries":["nexus3.onap.org:10001","nexus3.onap.org"],
}
EOF

DNS=$(cat /opt/config/external_dns.txt)
sed "s/}/  \"dns\":\[$DNS\]\n&/" /etc/docker/daemon.json

service docker restart

docker login -u $NEXUS_USERNAME -p $NEXUS_PASSWD $NEXUS_DOCKER_REPO
docker pull $NEXUS_DOCKER_REPO/onap/aai/esr-server:$DOCKER_IMAGE_VERSION
docker pull $NEXUS_DOCKER_REPO/onap/aai/esr-gui:$DOCKER_IMAGE_VERSION

docker rm -f esr_server
docker rm -f esr_gui

docker run -i -t -d -p 9518:9518 -e MSB_ADDR=$OPENO_IP:80 --name esr_server $NEXUS_DOCKER_REPO/onap/aai/esr-server:$DOCKER_IMAGE_VERSION
docker run -i -t -d -p 9519:8080 -e MSB_ADDR=$OPENO_IP:80 --name esr_gui $NEXUS_DOCKER_REPO/onap/aai/esr-gui:$DOCKER_IMAGE_VERSION