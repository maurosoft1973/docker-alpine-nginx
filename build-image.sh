#!/bin/bash
# Description: Build image and push to repository
# Maintainer: Mauro Cardillo
# DOCKER_HUB_USER and DOCKER_HUB_PASSWORD is user environment variable
BUILD_DATE=$(date +"%Y-%m-%d")
IMAGE=maurosoft1973/alpine-nginx

echo "# Image               : ${IMAGE}"
echo "# Build Date          : ${BUILD_DATE}"

echo "Remove image ${IMAGE}:test"
docker rmi -f ${IMAGE}:test > /dev/null 2>&1
docker rmi -f ${IMAGE}:test-geo > /dev/null 2>&1

echo "Build Image: ${IMAGE}:test"
docker build --build-arg BUILD_DATE=$BUILD_DATE -t ${IMAGE}:test -f ./Dockerfile .
docker build --build-arg BUILD_DATE=$BUILD_DATE -t ${IMAGE}:geo-test -f ./DockerfileGeo .

#echo "Login Docker HUB"
echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

docker push ${IMAGE}:test
docker push ${IMAGE}:geo-test
