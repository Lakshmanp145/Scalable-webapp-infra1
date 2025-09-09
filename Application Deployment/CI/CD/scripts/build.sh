#!/bin/bash
set -e

IMAGE_TAG=$1
ECR_REPO=$2
AWS_REGION=$3

docker build -t $ECR_REPO:$IMAGE_TAG ./app
docker tag $ECR_REPO:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
