#!/bin/bash

# Docker build and push script
# Usage: ./docker-build-push.sh <your-dockerhub-username>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <dockerhub-username>"
    echo "Example: $0 myusername"
    exit 1
fi

DOCKERHUB_USERNAME=$1
IMAGE_NAME="flask-docker-app"
TAG="latest"
FULL_IMAGE_NAME="${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "Building Docker image: ${FULL_IMAGE_NAME}"

# Build the Docker image
docker build -t ${FULL_IMAGE_NAME} .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
    
    # Push to DockerHub
    echo "Pushing image to DockerHub..."
    docker push ${FULL_IMAGE_NAME}
    
    if [ $? -eq 0 ]; then
        echo "✅ Image pushed successfully to DockerHub!"
        echo "Image available at: ${FULL_IMAGE_NAME}"
    else
        echo "❌ Failed to push image to DockerHub"
        exit 1
    fi
else
    echo "❌ Failed to build Docker image"
    exit 1
fi

# Test the image locally
echo "Testing the image locally..."
echo "Running: docker run -p 5000:5000 ${FULL_IMAGE_NAME}"
echo "You can access the app at http://localhost:5000"
echo "Press Ctrl+C to stop the container"

docker run -p 5000:5000 ${FULL_IMAGE_NAME}
