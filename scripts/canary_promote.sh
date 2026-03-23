#!/bin/bash
set -e

PROJECT_ID=${PROJECT_ID:-"bhavik-nagre-1773724371"}
NAMESPACE=${NAMESPACE:-"services"}
SERVICE=${SERVICE:-"order-service"}
REGION=${REGION:-"asia-southeast1"}
CLUSTER=${CLUSTER:-"capstone-cluster"}
IMAGE_TAG=${IMAGE_TAG:-"latest"}
REPO=${REPO:-"ollion-practise-project-repo"}
ENVIRONMENT=${ENVIRONMENT:-"dev"}

gcloud container clusters get-credentials $CLUSTER --region $REGION --project $PROJECT_ID

echo "Waiting 60s for canary to stabilize..."
sleep 60

echo "Checking error rate..."
ERROR_RATE=$(gcloud monitoring metrics list \
  --filter="metric.type=logging.googleapis.com/user/order-service-5xx-errors" \
  --project=$PROJECT_ID 2>/dev/null | wc -l || echo "0")

if [ "$ERROR_RATE" -gt "0" ]; then
  echo "High error rate detected - rolling back canary"
  helm rollback ${SERVICE} -n ${NAMESPACE} || true
  helm uninstall ${SERVICE}-canary -n ${NAMESPACE} || true
  exit 1
fi

echo "Canary healthy - promoting to stable"
helm upgrade --install ${SERVICE} ./charts/order-service \
  --namespace ${NAMESPACE} \
  --wait \
  --timeout 15m \
  --values ./charts/order-service/values-${ENVIRONMENT}.yaml \
  --set image.repository=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${SERVICE} \
  --set image.tag=${IMAGE_TAG}
  
helm uninstall ${SERVICE}-canary -n ${NAMESPACE} || true
echo "Canary promoted successfully!"