#!/bin/bash
set -e
ENV=$1
NAMESPACE="scalable-app"
SERVICE_NAME="scalable-webapp-svc"

# Get cluster-internal service URL
POD_NAME=$(kubectl -n $NAMESPACE get pod -l app=scalable-webapp -o jsonpath="{.items[0].metadata.name}")

kubectl -n $NAMESPACE exec $POD_NAME -- curl -f http://localhost:5000/ || { echo "Integration test failed"; exit 1; }

echo "Integration test passed!"
