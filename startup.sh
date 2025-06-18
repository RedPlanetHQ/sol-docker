#!/bin/bash
sudo mkdir -p /efs
sudo mount -t efs fs-0638e1b02b250066b:/ /efs

sudo mkdir -p /efs/qdrant
sudo chmod 777 /efs/qdrant 

# Check if the docker directory exists
if [ -d "./docker" ]; then
    echo "Removing existing core directory..."
    sudo rm -rf ./docker
fi

# Clone the repository
git clone https://github.com/RedPlanetHQ/sol-docker.git docker

# Make sure you have permission to write to it
sudo chown $(whoami) docker
sudo chmod 755 docker

# Fetch the .env file from AWS Secrets Manager
aws secretsmanager get-secret-value --secret-id sol-prod --query SecretString --output text > docker/.env

# Navigate to the app directory
cd ./docker

# Start Docker containers
docker compose up -d
