#!/bin/bash

# Full deployment script
# This script handles the complete deployment pipeline

set -e

echo "🚀 Starting Flask App Deployment Pipeline"
echo "========================================"

# Check if DockerHub username is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <dockerhub-username>"
    echo "Example: $0 myusername"
    exit 1
fi

DOCKERHUB_USERNAME=$1
IMAGE_NAME="flask-docker-app"
TAG="latest"
FULL_IMAGE_NAME="${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "📦 Step 1: Building Docker image"
echo "Building: ${FULL_IMAGE_NAME}"

# Build Docker image
docker build -t ${FULL_IMAGE_NAME} .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
else
    echo "❌ Failed to build Docker image"
    exit 1
fi

echo "📤 Step 2: Pushing to DockerHub"
docker push ${FULL_IMAGE_NAME}

if [ $? -eq 0 ]; then
    echo "✅ Image pushed to DockerHub successfully!"
else
    echo "❌ Failed to push image to DockerHub"
    exit 1
fi

echo "⚙️  Step 3: Preparing Terraform configuration"
cd terraform

# Create terraform.tfvars from example if it doesn't exist
if [ ! -f terraform.tfvars ]; then
    cp terraform.tfvars.example terraform.tfvars
    sed -i "s/YOUR_DOCKERHUB_USERNAME/${DOCKERHUB_USERNAME}/g" terraform.tfvars
    echo "📝 Created terraform.tfvars - please review and update if needed"
fi

echo "🏗️  Step 4: Initializing Terraform"
terraform init

echo "📋 Step 5: Planning Terraform deployment"
terraform plan -var="docker_image=${FULL_IMAGE_NAME}"

echo "🚀 Step 6: Applying Terraform configuration"
echo "This will create AWS resources. Do you want to continue? (y/n)"
read -r response

if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    terraform apply -var="docker_image=${FULL_IMAGE_NAME}" -auto-approve
    
    if [ $? -eq 0 ]; then
        echo "✅ Terraform deployment completed successfully!"
        echo ""
        echo "🎉 Deployment Summary:"
        echo "====================="
        terraform output
        echo ""
        echo "💡 Next Steps:"
        echo "1. Wait 2-3 minutes for the instance to fully boot up"
        echo "2. Access your Flask app using the provided URL"
        echo "3. SSH into the instance using the provided SSH command"
        echo "4. Check logs: docker logs flask-app"
    else
        echo "❌ Terraform deployment failed"
        exit 1
    fi
else
    echo "❌ Deployment cancelled by user"
    exit 1
fi

echo ""
echo "✨ Deployment pipeline completed!"
