#!/bin/bash
#PLATBPSRC=https://github.com/peerless1230/onap_heat/softwares

echo Look in /tmp/pgaas.out for output from installing PGaaS
NEXUS=https://nexus.onap.org/service/local/repositories/raw/content/org.onap.ccsdk.storage.pgaas/releases/debs
for pkg in cdf.deb-1.0.0 pgaas.deb-1.0.0
do
    OUT=./$pkg
    curl -k -f -o $OUT $NEXUS/$pkg
    #dpkg --install $OUT
done
