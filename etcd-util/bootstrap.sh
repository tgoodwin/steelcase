CONTROL_PLANE_CONTAINER="kind-control-plane"

docker exec $CONTROL_PLANE_CONTAINER /bin/sh -c "curl -LO https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-amd64.tar.gz"
docker exec $CONTROL_PLANE_CONTAINER /bin/sh -c "tar xzvf etcd-v3.5.0-linux-amd64.tar.gz"
docker exec $CONTROL_PLANE_CONTAINER /bin/sh -c "cd etcd-v3.5.0-linux-amd64 && mv etcd* /usr/bin"
if [[ $(docker exec $CONTROL_PLANE_CONTAINER /bin/sh -c "which etcdctl") != "/usr/bin/etcdctl" ]]; then
    exit 1;
fi;
docker exec $CONTROL_PLANE_CONTAINER /bin/sh -c "echo \"alias ectl='etcdctl --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key'\" >> ~/.bash_aliases"
exit 0;

