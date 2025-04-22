#!/bin/sh

# Set variables
IMAGE_NAME="dannyhuigen1/postgress-s3-backup"
TAG="latest"

# Build the Docker image
docker build -t $IMAGE_NAME:$TAG .

# Push the image to Docker Hub
docker push $IMAGE_NAME:$TAG
