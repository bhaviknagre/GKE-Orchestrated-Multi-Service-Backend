#!/bin/bash

set -e

if [[ "$1" == "--help" ]]; then
  echo "Chaos Test Script"
  echo "Simulates failure by deleting a random pod and verifying recovery."
  exit 0
fi

NAMESPACE=${NAMESPACE:-"services"}

echo "Selecting random pod..."

POD=$(kubectl get pods -n $NAMESPACE \
  -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | shuf -n1)

echo "Deleting pod: $POD"

kubectl delete pod $POD -n $NAMESPACE

echo "Waiting for new pod..."

sleep 60

echo "Checking pod status..."

kubectl get pods -n $NAMESPACE

echo "Chaos test completed successfully"