#!/bin/bash
# Description: Build image and push to repository
# Maintainer: Mauro Cardillo
# DOCKER_HUB_USER and DOCKER_HUB_PASSWORD is user environment variable
source ./.env

BUILD_DATE=$(date +"%Y-%m-%d")
IMAGE=maurosoft1973/alpine-nginx

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -av=*|--alpine-version=*)
        ALPINE_VERSION="${arg#*=}"
        shift # Remove
        ;;
        -nv=*|--nginx-version=*)
        NGINX_VERSION="${arg#*=}"
        shift # Remove
        ;;
        -nvd=*|--nginx-version-date=*)
        NGINX_VERSION_DATE="${arg#*=}"
        shift # Remove
        ;;
        -mv=*|--maxmind-version=*)
        MAXMIND_VERSION="${arg#*=}"
        shift # Remove
        ;;
        -r=*|--release=*)
        RELEASE="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
        echo -e "  -av=|--alpine-version=${ALPINE_VERSION} -> alpine version"
        echo -e "  -nv=|--nginx-version=${NGINX_VERSION} -> nginx version"
        echo -e "  -nvd=|--nginx-version-date=${NGINX_VERSION_DATE} -> nginx version date"
        echo -e "  -mv=|--maxmind-version=${MAXMIND_VERSION} -> maxmind version"
        echo -e "  -r=|--release=${RELEASE} -> release of image"
        exit 0
        ;;
    esac
done

echo "# Image               : ${IMAGE}"
echo "# Image Release       : ${RELEASE}"
echo "# Build Date          : ${BUILD_DATE}"
echo "# Alpine Version      : ${ALPINE_VERSION}"
echo "# Nginx Version       : ${NGINX_VERSION}"
echo "# Nginx Version Date  : ${NGINX_VERSION_DATE}"

if [ "$RELEASE" == "TEST" ]; then
    echo "Remove image ${IMAGE}:test"
    docker rmi -f ${IMAGE}:test > /dev/null 2>&1

    echo "Remove image ${IMAGE}:${NGINX_VERSION}-test"
    docker rmi -f ${IMAGE}:${NGINX_VERSION}-test > /dev/null 2>&1

    echo "Remove image ${IMAGE}:geo-test"
    docker rmi -f ${IMAGE}:geo-test > /dev/null 2>&1

    echo "Remove image ${IMAGE}:geo-${NGINX_VERSION}-test"
    docker rmi -f ${IMAGE}:geo-${NGINX_VERSION}-test > /dev/null 2>&1

    echo "Build Image: ${IMAGE} -> ${RELEASE}"
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg MAXMIND_VERSION=${MAXMIND_VERSION} -t ${IMAGE}:test -t ${IMAGE}:${NGINX_VERSION}-test -f ./Dockerfile .
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg MAXMIND_VERSION=${MAXMIND_VERSION} -t ${IMAGE}:geo-test -t ${IMAGE}:geo-${NGINX_VERSION}-test -f ./DockerfileGeo .

    echo "Login Docker HUB"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Push Image -> ${IMAGE}:${NGINX_VERSION}-test"
    docker push ${IMAGE}:${NGINX_VERSION}-test

    echo "Push Image -> ${IMAGE}:test"
    docker push ${IMAGE}:test

    echo "Push Image -> ${IMAGE}:geo-${NGINX_VERSION}-test"
    docker push ${IMAGE}:geo-${NGINX_VERSION}-test

    echo "Push Image -> ${IMAGE}:geo-test"
    docker push ${IMAGE}:geo-test
elif [ "$RELEASE" == "CURRENT" ]; then
    echo "Remove image ${IMAGE}:${NGINX_VERSION}"
    docker rmi -f ${IMAGE}:${NGINX_VERSION} > /dev/null 2>&1

    echo "Remove image ${IMAGE}:${NGINX_VERSION}-amd64"
    docker rmi -f ${IMAGE}:${NGINX_VERSION}-amd64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:${NGINX_VERSION}-x86_64"
    docker rmi -f ${IMAGE}:${NGINX_VERSION}-x86_64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:geo-${NGINX_VERSION}"
    docker rmi -f ${IMAGE}:geo-${NGINX_VERSION} > /dev/null 2>&1

    echo "Remove image ${IMAGE}:geo-${NGINX_VERSION}-amd64"
    docker rmi -f ${IMAGE}:geo-${NGINX_VERSION}-amd64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:geo-${NGINX_VERSION}-x86_64"
    docker rmi -f ${IMAGE}:geo-${NGINX_VERSION}-x86_64 > /dev/null 2>&1

    echo "Build Image: ${IMAGE} -> ${RELEASE}"
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg MAXMIND_VERSION=${MAXMIND_VERSION} -t ${IMAGE}:${NGINX_VERSION} -t ${IMAGE}:${NGINX_VERSION}-amd64 -t ${IMAGE}:${NGINX_VERSION}-x86_64 -f ./Dockerfile .
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg MAXMIND_VERSION=${MAXMIND_VERSION} -t ${IMAGE}:geo-${NGINX_VERSION} -t ${IMAGE}:geo-${NGINX_VERSION}-amd64 -t ${IMAGE}:geo-${NGINX_VERSION}-x86_64 -f ./DockerfileGeo .

    echo "Login Docker HUB"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Push Image -> ${IMAGE}:${NGINX_VERSION}"
    docker push ${IMAGE}:${NGINX_VERSION}

    echo "Push Image -> ${IMAGE}:${NGINX_VERSION}-amd64"
    docker push ${IMAGE}:${NGINX_VERSION}-amd64

    echo "Push Image -> ${IMAGE}:${NGINX_VERSION}-x86_64"
    docker push ${IMAGE}:${NGINX_VERSION}-x86_64

    echo "Push Image -> ${IMAGE}:geo-${NGINX_VERSION}-amd64"
    docker push ${IMAGE}:geo-${NGINX_VERSION}-amd64

    echo "Push Image -> ${IMAGE}:geo-${NGINX_VERSION}-x86_64"
    docker push ${IMAGE}:geo-${NGINX_VERSION}-x86_64

    echo "Push Image -> ${IMAGE}:geo-${NGINX_VERSION}"
    docker push ${IMAGE}:geo-${NGINX_VERSION}
else
    echo "Remove image ${IMAGE}:latest"
    docker rmi -f ${IMAGE}:latest > /dev/null 2>&1

    echo "Remove image ${IMAGE}:amd64"
    docker rmi -f ${IMAGE}:amd64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:x86_64"
    docker rmi -f ${IMAGE}:x86_64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:geo"
    docker rmi -f ${IMAGE}:geo > /dev/null 2>&1

    echo "Remove image ${IMAGE}:geo-amd64"
    docker rmi -f ${IMAGE}:geo-amd64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:geo-x86_64"
    docker rmi -f ${IMAGE}:geo-x86_64 > /dev/null 2>&1

    echo "Build Image: ${IMAGE} -> ${RELEASE}"
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg MAXMIND_VERSION=${MAXMIND_VERSION} -t ${IMAGE}:latest -t ${IMAGE}:amd64 -t ${IMAGE}:x86_64 -f ./Dockerfile .
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg MAXMIND_VERSION=${MAXMIND_VERSION} -t ${IMAGE}:geo -t ${IMAGE}:geo-amd64 -t ${IMAGE}:geo-x86_64 -f ./DockerfileGeo .

    echo "Login Docker HUB"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Push Image -> ${IMAGE}:latest"
    docker push ${IMAGE}:latest

    echo "Push Image -> ${IMAGE}:amd64"
    docker push ${IMAGE}:amd64

    echo "Push Image -> ${IMAGE}:x86_64"
    docker push ${IMAGE}:x86_64

    echo "Push Image -> ${IMAGE}:geo-amd64"
    docker push ${IMAGE}:geo-amd64

    echo "Push Image -> ${IMAGE}:geo-x86_64"
    docker push ${IMAGE}:geo-x86_64

    echo "Push Image -> ${IMAGE}:geo"
    docker push ${IMAGE}:geo
fi

