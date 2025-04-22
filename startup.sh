#!/bin/bash
# Check if the docker directory exists
if [ -d "./docker" ]; then
    echo "Removing existing docker directory..."
    rm -rf ./docker
fi

# Clone the repository
git clone https://github.com/tegonhq/sigma-docker.git docker

# Fetch the .env file from Secret Manager
gcloud secrets versions access latest --secret=sigma-prod > docker/.env

mkdir -p ./docker/certs
gcloud secrets versions access latest --secret=tegon-gcs > docker/certs/tegon-gcs.json


# Navigate to the app directory
cd ./docker

# Read the VERSION from the .env file
export VERSION=$(grep -oP '(?<=VERSION=).*' .env)


docker pull tegonhq/sigma-server:$VERSION
docker pull tegonhq/sigma-webapp:$VERSION

docker compose up -d