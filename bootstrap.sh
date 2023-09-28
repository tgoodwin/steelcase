#!/bin/bash

set -euxo pipefail


K8s_CLUSTER_NAME="steelcase";
KNATIVE_SERVING_REPO="${HOME}/knative-serving"

function cleanup() {
    kind delete cluster --name $K8S_CLUSTER_NAME

    cd $KNATIVE_SERVING_REPO
    ko delete --ignore-not-found=true \
        -Rf config/core/ \
        -f ./thord_party/kourier-latest/kourier.yaml \
        -f ./third_party/cert-manager-latest/cert-manager.yaml
}

# create cluster from config file
if [[ $(kind get clusters) != $K8s_CLUSTER_NAME ]]; then
    echo "creating cluster..."
    kind create cluster --name $K8s_CLUSTER_NAME --config cluster-config.yaml
fi

# install knative serving from source
echo "installing knative from source at ${KNATIVE_SERVING_REPO}"
cd $KNATIVE_SERVING_REPO

# install CRDs
ko apply --selector knative.dev/crd-install=true -Rf config/core/
kubectl wait --for=condition=Established --all crd

# create namespace and spin up pods
ko apply -Rf config/core

# go back
cd -

# set up networking using Kourier
echo "setting up networking..."
kubectl apply --filename kourier.yaml

# set Kourier as the default networking layer for knative serving
kubectl patch configmap/config-network \
    --namespace knative-serving \
    --type merge \
    --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

# patch the domain configuration for knative with a 'magic' DNS provider
kubectl patch configmap/config-domain \
    --namespace knative-serving \
    --type merge \
    --patch '{"data":{"127.0.0.1.sslip.io":""}}'


echo "done!"
