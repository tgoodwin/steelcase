#!/bin/bash

# tails log statements for controllers (NOT AUDIT LOGS)
kubectl -n knative-serving logs $(kubectl -n knative-serving get pods -l app=controller -o name) -c controller -f
