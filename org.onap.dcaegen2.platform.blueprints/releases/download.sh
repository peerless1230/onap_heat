#!/bin/bash
#PLATBPSRC=https://github.com/peerless1230/onap_heat/softwares
PLATBPSRC=https://nexus.onap.org/service/local/repositories/raw/content/org.onap.dcaegen2.platform.blueprints/releases/blueprints
DOCKERBP=DockerBP.yaml
CBSBP=config_binding_service.yaml
PGBP=pgaas-onevm.yaml
CDAPBP=cdapbp7.yaml
CDAPBROKERBP=cdap_broker.yaml
INVBP=inventory.yaml
DHBP=DeploymentHandler.yaml
PHBP=policy_handler.yaml
VESBP=ves.yaml
TCABP=tca.yaml
HRULESBP=holmes-rules.yaml
HENGINEBP=holmes-engine.yaml

wget $PLATBPSRC/$DOCKERBP
wget $PLATBPSRC/$DOCKERBP
wget $PLATBPSRC/$CBSBP
wget $PLATBPSRC/$PGBP
wget $PLATBPSRC/$CDAPBP
wget $PLATBPSRC/$CDAPBROKERBP
wget $PLATBPSRC/$INVBP
wget $PLATBPSRC/$DHBP
wget $PLATBPSRC/$PHBP
wget $PLATBPSRC/$VESBP
wget $PLATBPSRC/$TCABP
wget $PLATBPSRC/$HRULESBP
wget $PLATBPSRC/$HENGINEBP

