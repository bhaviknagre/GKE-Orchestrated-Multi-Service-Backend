#!/bin/bash

set -e

if [[ "$1" == "--help" ]]; then
  echo "Terraform Plan Checker"
  echo "Checks Terraform plan output for destructive changes."
  exit 0
fi

PLAN_FILE=${PLAN_FILE:-"tfplan.txt"}

if [[ ! -f "$PLAN_FILE" ]]; then
  echo "Terraform plan file not found."
  exit 1
fi

echo "Checking Terraform plan..."

DESTROY_COUNT=$(grep "destroy" $PLAN_FILE | wc -l)

if [[ $DESTROY_COUNT -gt 0 && "$ALLOW_DESTROY" != "true" ]]; then
  echo "Destructive changes detected. Pipeline blocked."
  exit 1
fi

echo "Terraform plan is safe."