#!/bin/bash
set -euxo pipefail
AWS_REGION="us-east-1"
ECR_REGISTRY="661303382830.dkr.ecr.us-east-1.amazonaws.com"
ECR_REPOSITORY="wordpress"
IMAGE_TAG="latest"
cd /opt/wordpress
aws ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin $ECR_REGISTRY
docker pull $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
docker-compose down || true
docker-compose up -d
