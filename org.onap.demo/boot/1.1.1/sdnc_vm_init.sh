#!/bin/bash

NEXUS_USERNAME=$(cat /opt/config/nexus_username.txt)
NEXUS_PASSWD=$(cat /opt/config/nexus_password.txt)
export NEXUS_DOCKER_REPO=$(cat /opt/config/nexus_docker_repo.txt)
DOCKER_IMAGE_VERSION=$(cat /opt/config/docker_version.txt)
DGBUILDER_IMAGE_VERSION=$(cat /opt/config/dgbuilder_version.txt)
export MTU=$(/sbin/ifconfig | grep MTU | sed 's/.*MTU://' | sed 's/ .*//' | sort -n | head -1)
export DNS_IP_ADDR=$(cat /opt/config/dns_ip_addr.txt)

cd /opt/sdnc
git pull

cd /opt/sdnc/installation/src/main/yaml
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

docker pull $NEXUS_DOCKER_REPO/onap/sdnc-image:$DOCKER_IMAGE_VERSION
docker tag $NEXUS_DOCKER_REPO/onap/sdnc-image:$DOCKER_IMAGE_VERSION onap/sdnc-image:latest

docker pull $NEXUS_DOCKER_REPO/onap/admportal-sdnc-image:$DOCKER_IMAGE_VERSION
docker tag $NEXUS_DOCKER_REPO/onap/admportal-sdnc-image:$DOCKER_IMAGE_VERSION onap/admportal-sdnc-image:latest

docker pull $NEXUS_DOCKER_REPO/onap/ccsdk-dgbuilder-image:$DGBUILDER_IMAGE_VERSION
docker tag $NEXUS_DOCKER_REPO/onap/ccsdk-dgbuilder-image:$DGBUILDER_IMAGE_VERSION onap/ccsdk-dgbuilder-image:latest

docker pull $NEXUS_DOCKER_REPO/onap/sdnc-ueb-listener-image:$DOCKER_IMAGE_VERSION
docker tag $NEXUS_DOCKER_REPO/onap/sdnc-ueb-listener-image:$DOCKER_IMAGE_VERSION onap/sdnc-ueb-listener-image:latest

docker pull $NEXUS_DOCKER_REPO/onap/sdnc-dmaap-listener-image:$DOCKER_IMAGE_VERSION
docker tag $NEXUS_DOCKER_REPO/onap/sdnc-dmaap-listener-image:$DOCKER_IMAGE_VERSION onap/sdnc-dmaap-listener-image:latest

/opt/docker/docker-compose up -d
