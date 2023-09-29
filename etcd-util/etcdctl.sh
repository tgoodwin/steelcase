#! /bin/bash

"forwards etcdctl commands to the client on the control plane node so that we can talk to the etcd cluster that kind is running"

CERTPATH="/etc/kubernetes/pki/etcd"
echo "$*"
docker exec kind-control-plane /bin/sh -c "ETCDCTL_API=3 etcdctl --cacert $CERTPATH/ca.crt  --cert $CERTPATH/healthcheck-client.crt  --key $CERTPATH/healthcheck-client.key ${*}"


