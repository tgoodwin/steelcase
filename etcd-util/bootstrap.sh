CONTROL_PLANE_CONTAINER="kind-control-plane"

docker exec $CONTROL_PLANE_CONTAINER /bin/sh -c "curl -LO https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-amd64.tar.gz"
docker exec $CONTROL_PLANE_CONTAINER /bin/sh -c "tar xzvf etcd-v3.5.0-linux-amd64.tar.gz"
docker exec $CONTROL_PLANE_CONTAINER /bin/sh -c "cd etcd-v3.5.0-linux-amd64"

