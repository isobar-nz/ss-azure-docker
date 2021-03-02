#!/usr/bin/env bash

# Run from project-root (as below)
# ./.docker/build.sh

# Clone site to build location first
REPO_BRANCH=$(git rev-parse --abbrev-ref HEAD)
REPO_ORIGIN=$(git remote get-url origin)
REPO_TAG=$(git describe --exact-match --tags 2>/dev/null)
RELEASE_ID=$(uuidgen)
RELEASE_TAG=${RELEASE_ID:0:8}

echo "Building release ID \"${RELEASE_ID}\" with tags:"
echo " - ${RELEASE_TAG} (dev)"
if [[ $REPO_TAG != "" ]]; then
    echo " - '${REPO_TAG}' (stable)"
fi

# Clear old images
echo "Clearing old images"
docker stop $(docker ps -aq)
docker rmi --force $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'vendorname.azurecr.io/projectname-')

## Clear directory for build
echo "Generating build folder"
rm -rf ./.docker/build
mkdir -p ./.docker/build
git clone ${REPO_ORIGIN} -b ${REPO_BRANCH} ./.docker/build
SS_VENDOR_METHOD=copy composer install -d ./.docker/build

# Set release ID, copy to both webapps
echo "Marking release-id.txt"
echo "${RELEASE_ID}" >./.docker/build/webapp/public/release-id.txt
echo "${RELEASE_ID}" >./.docker/build/public/release-id.txt

# Build all the images
echo "Building docker images"
docker build -t vendorname.azurecr.io/projectname-php -f ./.docker/php/Dockerfile ./.docker
docker build -t vendorname.azurecr.io/projectname-node -f ./.docker/node/Dockerfile ./.docker
docker build -t vendorname.azurecr.io/projectname-nginx -f ./.docker/nginx/Dockerfile ./.docker

# Tag release
echo "Tagging docker images (id)"
docker tag vendorname.azurecr.io/projectname-php vendorname.azurecr.io/projectname-php:${RELEASE_TAG}
docker tag vendorname.azurecr.io/projectname-node vendorname.azurecr.io/projectname-node:${RELEASE_TAG}
docker tag vendorname.azurecr.io/projectname-nginx vendorname.azurecr.io/projectname-nginx:${RELEASE_TAG}

# tag stable (if doing a stable release)
if [[ $REPO_TAG != "" ]]; then
    echo "Tagging docker images (stable)"
    docker tag vendorname.azurecr.io/projectname-php vendorname.azurecr.io/projectname-php:${REPO_TAG}
    docker tag vendorname.azurecr.io/projectname-node vendorname.azurecr.io/projectname-node:${REPO_TAG}
    docker tag vendorname.azurecr.io/projectname-nginx vendorname.azurecr.io/projectname-nginx:${REPO_TAG}
fi
