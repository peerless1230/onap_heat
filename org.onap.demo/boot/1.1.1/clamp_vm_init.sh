#!/bin/bash

NEXUS_USERNAME=$(cat /opt/config/nexus_username.txt)
NEXUS_PASSWD=$(cat /opt/config/nexus_password.txt)
NEXUS_DOCKER_REPO=$(cat /opt/config/nexus_docker_repo.txt)
DOCKER_IMAGE_VERSION=$(cat /opt/config/docker_version.txt)

# Fetch the latest code/scripts
cd /opt/clamp
git pull

# Remove unused folders as only extra/ folder is used for docker compose
rm -rf pom.xml
rm -rf src/

# No configuration change here as directly done in the CLAMP repo

# Pull the clamp docker image from nexus
# Maria db will be pulled automatically from docker.io during docker-compose
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

docker pull $NEXUS_DOCKER_REPO/onap/clamp:$DOCKER_IMAGE_VERSION

cd extra/docker/clamp/

# Change the Clamp docker image name in the docker-compose.yml to match the one downloaded
sed -i "/image: onap\/clamp/c\    image: $NEXUS_DOCKER_REPO\/onap\/clamp:$DOCKER_IMAGE_VERSION" docker-compose.yml

# Start Clamp and MariaDB containers with docker compose and clamp/extra/docker/clamp/docker-compose.yml
/opt/docker/docker-compose up -d
