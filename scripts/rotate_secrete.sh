#!/bin/bash

set -e

if [[ "$1" == "--help" ]]; then
  echo "Secret Rotation Script"
  echo "Rotates DB password in Secret Manager and restarts services."
  exit 0
fi

PROJECT_ID=$(gcloud config get-value project)
SECRET_NAME="db-password"
NAMESPACE="services"

NEW_PASSWORD=$(openssl rand -base64 16)

echo "Updating secret..."

echo -n $NEW_PASSWORD | gcloud secrets versions add $SECRET_NAME \
  --data-file=- \
  --project $PROJECT_ID

echo "Restarting services..."

kubectl rollout restart deployment order-service -n $NAMESPACE
kubectl rollout restart deployment inventory-service -n $NAMESPACE

echo "Waiting for rollout..."

kubectl rollout status deployment order-service -n $NAMESPACE
kubectl rollout status deployment inventory-service -n $NAMESPACE

echo "Secret rotation completed"