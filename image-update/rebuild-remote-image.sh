#!/bin/bash

DOCKER_REPO="apfelwurm/csgo-get5-docker-dev"
NEW_TAG=$(curl -s 'http://api.steampowered.com/ISteamApps/UpToDateCheck/v1?appid=730&version=$1' | jq .response.required_version)

if [ ! -f "Dockerfile" ]; then
    echo "Dockerfile does not exist. Please run this script in the root of the repository!"
    exit 1
fi

echo "Building version $NEW_TAG of $DOCKER_REPO"

echo "deleting old images"
docker images | grep "$DOCKER_REPO" | awk '{system("docker rmi " $1 ":" $2)}'

echo "build container..."
DOCKER_BUILDKIT=1 docker build --no-cache . -t $DOCKER_REPO:latest

echo "Committing changes..."
docker image tag "$DOCKER_REPO:latest" "$DOCKER_REPO:$NEW_TAG"

echo "Pushing to registry..."
docker push "$DOCKER_REPO:latest"
docker push "$DOCKER_REPO:$NEW_TAG"
