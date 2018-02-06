#!/bin/bash

NEXUS_USERNAME=$(cat /opt/config/nexus_username.txt)
NEXUS_PASSWD=$(cat /opt/config/nexus_password.txt)
export NEXUS_DOCKER_REPO=$(cat /opt/config/nexus_docker_repo.txt)
DMAAP_TOPIC=$(cat /opt/config/dmaap_topic.txt)
DOCKER_IMAGE_VERSION=$(cat /opt/config/docker_version.txt)
DGBUILDER_IMAGE_VERSION=$(cat /opt/config/dgbuilder_version.txt)
export MTU=$(/sbin/ifconfig | grep MTU | sed 's/.*MTU://' | sed 's/ .*//' | sort -n | head -1)

cd /opt/appc
git pull
cd /opt/appc/docker-compose

sed -i "s/DMAAP_TOPIC_ENV=.*/DMAAP_TOPIC_ENV="$DMAAP_TOPIC"/g" docker-compose.yml

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

docker pull $NEXUS_DOCKER_REPO/openecomp/appc-image:$DOCKER_IMAGE_VERSION
docker tag $NEXUS_DOCKER_REPO/openecomp/appc-image:$DOCKER_IMAGE_VERSION openecomp/appc-image:latest

docker pull $NEXUS_DOCKER_REPO/onap/ccsdk-dgbuilder-image:$DGBUILDER_IMAGE_VERSION
docker tag $NEXUS_DOCKER_REPO/onap/ccsdk-dgbuilder-image:$DGBUILDER_IMAGE_VERSION onap/ccsdk-dgbuilder-image:latest

/opt/docker/docker-compose up -d
