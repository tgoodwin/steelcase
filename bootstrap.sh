#!/bin/bash

K8s_CLUSTER_NAME="steelcase";
KNATIVE_SERVING_REPO="${HOME}/knative-serving"

# create cluster from config file
echo "creating cluster..."
kind create cluster --name $K8s_CLUSTER_NAME --config cluster-config.yaml

# install knative serving from source
echo "installing knative from source at ${KNATIVE_SERVING_REPO}"
cd $KNATIVE_SERVING_REPO
ls
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
