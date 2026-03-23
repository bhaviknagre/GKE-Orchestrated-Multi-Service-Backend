#!/bin/bash

set -e

if [[ "$1" == "--help" ]]; then
  echo "Internal Communication Test"
  echo "Tests Order Service calling Inventory Service internally."
  exit 0
fi

NAMESPACE=${NAMESPACE:-"services"}

echo "Finding Order Service pod..."

POD=$(kubectl get pods -n $NAMESPACE \
  -l app=order-service \
  -o jsonpath="{.items[0].metadata.name}")

echo "Using pod: $POD"

echo "Calling Inventory Service..."

kubectl exec -n $NAMESPACE $POD -- \
curl http://inventory-service:8080/inventory/check

echo "Internal communication successful"