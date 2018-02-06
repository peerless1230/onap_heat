#!/bin/bash

# Establish environment variables
NEXUS_USERNAME=$(cat /opt/config/nexus_username.txt)
NEXUS_PASSWD=$(cat /opt/config/nexus_password.txt)
NEXUS_DOCKER_REPO=$(cat /opt/config/nexus_docker_repo.txt)
DOCKER_IMAGE_VERSION=$(cat /opt/config/uui_docker.txt)

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
docker pull $NEXUS_DOCKER_REPO/onap/usecase-ui:$DOCKER_IMAGE_VERSION
docker pull $NEXUS_DOCKER_REPO/onap/usecase-ui/usecase-ui-server:$DOCKER_IMAGE_VERSION

docker rm -f uui_ui
docker rm -f uui_server

# Insert docker run instructions here
docker run -i -t -d --name uui_ui -p 8080:8080 -e MSB_ADDR=$OPENO_IP:80 $NEXUS_DOCKER_REPO/onap/usecase-ui:$DOCKER_IMAGE_VERSION
docker run -i -t -d --name uui_server -p 8082:8082 -e MSB_ADDR=$OPENO_IP:80 -e MR_ADDR=$MR_IP:3904 $NEXUS_DOCKER_REPO/onap/usecase-ui/usecase-ui-server:$DOCKER_IMAGE_VERSION