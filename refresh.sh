#!/bin/bash

set -eu

export SNAP_NAME="microk8s"
export SNAP_DATA="/var/snap/microk8s/current/"
export SNAP="/snap/microk8s/current/"

export PATH="$SNAP/usr/sbin:$SNAP/usr/bin:$SNAP/sbin:$SNAP/bin:$PATH"
source $SNAP/actions/common/utils.sh

if [ -e ${SNAP_DATA}/var/lock/clustered.lock ]
then
  echo "This MicroK8s deployment is acting as a node in a cluster. Please use the microk8s refresh-cert command on the master"
  echo "and then return to this node to perform a microk8s leave and re-join."
  exit 0
fi

if echo "$*" | grep -v -q -- '--kubeconfig'; then
  exit_if_no_permissions
fi

# Backup
BACKUP=$SNAP_DATA/var/log/ca-backup/
echo "Backing up certificates under $BACKUP"
mkdir -p $SNAP_DATA/var/log/ca-backup/
cp -r ${SNAP_DATA}/certs $BACKUP
cp -r ${SNAP_DATA}/credentials $BACKUP/

echo "Creating new certificates"
rm -rf ${SNAP_DATA}/certs/ca.crt
rm -rf ${SNAP_DATA}/certs/front-proxy-ca.crt
rm -rf ${SNAP_DATA}/certs/csr.conf
produce_certs
rm -rf .srl

# Create the basic tokens
echo "Creating new kubeconfig file"
mkdir -p ${SNAP_DATA}/credentials
admin_token=`grep admin ${SNAP_DATA}/credentials/basic_auth.csv | cut -d, -f1`
ca_data=$(cat ${SNAP_DATA}/certs/ca.crt | ${SNAP}/usr/bin/base64 -w 0)

# Create the client kubeconfig
cp ${SNAP}/client.config.template ${SNAP_DATA}/credentials/client.config
$SNAP/bin/sed -i 's/PASSWORD/'"${admin_token}"'/g' ${SNAP_DATA}/credentials/client.config
$SNAP/bin/sed -i 's/CADATA/'"${ca_data}"'/g' ${SNAP_DATA}/credentials/client.config
$SNAP/bin/sed -i 's/NAME/admin/g' ${SNAP_DATA}/credentials/client.config
$SNAP/bin/sed -i 's/AUTHTYPE/password/g' ${SNAP_DATA}/credentials/client.config
$SNAP/bin/sed -i 's/PASSWORD/'"${admin_token}"'/g' ${SNAP_DATA}/credentials/client.config

# Create the known tokens
proxy_token=`grep kube-proxy ${SNAP_DATA}/credentials/known_tokens.csv | cut -d, -f1`
hostname=$(hostname)
kubelet_token=`grep kubelet-0 ${SNAP_DATA}/credentials/known_tokens.csv | cut -d, -f1`
controller_token=`grep kube-controller-manager ${SNAP_DATA}/credentials/known_tokens.csv | cut -d, -f1`
scheduler_token=`grep kube-scheduler ${SNAP_DATA}/credentials/known_tokens.csv | cut -d, -f1`

# Create the client kubeconfig for the controller
cp ${SNAP}/client.config.template ${SNAP_DATA}/credentials/controller.config
$SNAP/bin/sed -i 's/CADATA/'"${ca_data}"'/g' ${SNAP_DATA}/credentials/controller.config
$SNAP/bin/sed -i 's/NAME/controller/g' ${SNAP_DATA}/credentials/controller.config
$SNAP/bin/sed -i '/username/d' ${SNAP_DATA}/credentials/controller.config
$SNAP/bin/sed -i 's/AUTHTYPE/token/g' ${SNAP_DATA}/credentials/controller.config
$SNAP/bin/sed -i 's/PASSWORD/'"${controller_token}"'/g' ${SNAP_DATA}/credentials/controller.config

# Create the client kubeconfig for the scheduler
cp ${SNAP}/client.config.template ${SNAP_DATA}/credentials/scheduler.config
$SNAP/bin/sed -i 's/CADATA/'"${ca_data}"'/g' ${SNAP_DATA}/credentials/scheduler.config
$SNAP/bin/sed -i 's/NAME/scheduler/g' ${SNAP_DATA}/credentials/scheduler.config
$SNAP/bin/sed -i '/username/d' ${SNAP_DATA}/credentials/scheduler.config
$SNAP/bin/sed -i 's/AUTHTYPE/token/g' ${SNAP_DATA}/credentials/scheduler.config
$SNAP/bin/sed -i 's/PASSWORD/'"${scheduler_token}"'/g' ${SNAP_DATA}/credentials/scheduler.config

# Create the proxy and kubelet kubeconfig
cp ${SNAP}/client.config.template ${SNAP_DATA}/credentials/kubelet.config
$SNAP/bin/sed -i 's/NAME/kubelet/g' ${SNAP_DATA}/credentials/kubelet.config
$SNAP/bin/sed -i 's/CADATA/'"${ca_data}"'/g' ${SNAP_DATA}/credentials/kubelet.config
$SNAP/bin/sed -i '/username/d' ${SNAP_DATA}/credentials/kubelet.config
$SNAP/bin/sed -i 's/AUTHTYPE/token/g' ${SNAP_DATA}/credentials/kubelet.config
$SNAP/bin/sed -i 's/PASSWORD/'"${kubelet_token}"'/g' ${SNAP_DATA}/credentials/kubelet.config

cp ${SNAP}/client.config.template ${SNAP_DATA}/credentials/proxy.config
$SNAP/bin/sed -i 's/NAME/kubeproxy/g' ${SNAP_DATA}/credentials/proxy.config
$SNAP/bin/sed -i 's/CADATA/'"${ca_data}"'/g' ${SNAP_DATA}/credentials/proxy.config
$SNAP/bin/sed -i '/username/d' ${SNAP_DATA}/credentials/proxy.config
$SNAP/bin/sed -i 's/AUTHTYPE/token/g' ${SNAP_DATA}/credentials/proxy.config
$SNAP/bin/sed -i 's/PASSWORD/'"${proxy_token}"'/g' ${SNAP_DATA}/credentials/proxy.config

echo "Restarting microK8s"
$SNAP/microk8s-stop.wrapper || true
$SNAP/microk8s-start.wrapper
