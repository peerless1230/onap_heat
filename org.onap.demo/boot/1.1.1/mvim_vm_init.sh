#!/bin/bash

# Establish environment variables
NEXUS_USERNAME=$(cat /opt/config/nexus_username.txt)
NEXUS_PASSWD=$(cat /opt/config/nexus_password.txt)
NEXUS_DOCKER_REPO=$(cat /opt/config/nexus_docker_repo.txt)
DOCKER_IMAGE_VERSION=$(cat /opt/config/mvim_docker.txt)

source /opt/config/onap_ips.txt

# Refresh images
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
docker pull $NEXUS_DOCKER_REPO/onap/multicloud/framework:$DOCKER_IMAGE_VERSION
docker pull $NEXUS_DOCKER_REPO/onap/multicloud/vio:$DOCKER_IMAGE_VERSION
docker pull $NEXUS_DOCKER_REPO/onap/multicloud/openstack-ocata:$DOCKER_IMAGE_VERSION
docker pull $NEXUS_DOCKER_REPO/onap/multicloud/openstack-windriver:$DOCKER_IMAGE_VERSION

docker rm -f multicloud-broker
docker rm -f multicloud-vio
docker rm -f multicloud-ocata
docker rm -f multicloud-windriver

docker run -d -t -e MSB_ADDR=$OPENO_IP -e AAI_ADDR=$AAI_IP1 -p 9001:9001 --name multicloud-broker $NEXUS_DOCKER_REPO/onap/multicloud/framework:$DOCKER_IMAGE_VERSION
docker run -d -t -e MSB_ADDR=$OPENO_IP -e AAI_ADDR=$AAI_IP1 -p 9004:9004 --name multicloud-vio $NEXUS_DOCKER_REPO/onap/multicloud/vio:$DOCKER_IMAGE_VERSION
docker run -d -t -e MSB_ADDR=$OPENO_IP -e AAI_ADDR=$AAI_IP1 -p 9006:9006 --name multicloud-ocata $NEXUS_DOCKER_REPO/onap/multicloud/openstack-ocata:$DOCKER_IMAGE_VERSION
docker run -d -t -e MSB_ADDR=$OPENO_IP -e AAI_ADDR=$AAI_IP1 -p 9005:9005 --name multicloud-windriver $NEXUS_DOCKER_REPO/onap/multicloud/openstack-windriver:$DOCKER_IMAGE_VERSION