#!/bin/bash

AAI_INSTANCE=$(cat /opt/config/aai_instance.txt)

cd /opt/test-config
git pull

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

if [[ $AAI_INSTANCE == "aai_instance_1" ]]
then
	./deploy_vm1.sh
elif [[ $AAI_INSTANCE == "aai_instance_2" ]]
then
	./deploy_vm2.sh
else
	echo "Invalid instance. Exiting..."
fi
