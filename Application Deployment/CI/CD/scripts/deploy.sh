#!/bin/bash
set -e
ENV=$1
IMAGE_TAG=$2

NAMESPACE="scalable-app"
DEPLOYMENT_NAME="scalable-webapp"

kubectl config use-context your-eks-cluster

# Update deployment image
kubectl -n $NAMESPACE set image deployment/$DEPLOYMENT_NAME webapp=123456789012.dkr.ecr.us-east-1.amazonaws.com/scalable-webapp:$IMAGE_TAG

# Wait until rollout completes
kubectl -n $NAMESPACE rollout status deployment/$DEPLOYMENT_NAME
