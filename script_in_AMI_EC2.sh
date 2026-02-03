#!/bin/bash
set -e

REGION=us-east-1
ACCOUNT_ID=661303382830
ECR_REGISTRY=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

aws ecr get-login-password --region $REGION \
| docker login --username AWS --password-stdin $ECR_REGISTRY
