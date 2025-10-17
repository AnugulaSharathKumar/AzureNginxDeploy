#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Starting Nginx Web App Deployment${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

# Build Docker image
echo -e "${YELLOW}📦 Building Docker image...${NC}"
docker build -t nginx-webapp:latest -f docker/Dockerfile .

# Test the container locally
echo -e "${YELLOW}🔧 Testing container locally...${NC}"
docker run -d --name nginx-webapp-test -p 8080:80 nginx-webapp:latest

# Wait for container to start
sleep 10

# Test the application
if curl -f http://localhost:8080/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Local test passed${NC}"
else
    echo -e "${RED}❌ Local test failed${NC}"
    docker stop nginx-webapp-test > /dev/null
    docker rm nginx-webapp-test > /dev/null
    exit 1
fi

# Stop test container
docker stop nginx-webapp-test > /dev/null
docker rm nginx-webapp-test > /dev/null

# Check if user is logged into Azure
echo -e "${YELLOW}🔐 Checking Azure login...${NC}"
if ! az account show > /dev/null 2>&1; then
    echo -e "${RED}❌ Not logged into Azure. Please run 'az login' first.${NC}"
    exit 1
fi

# Deploy with Terraform
echo -e "${YELLOW}🏗️ Deploying infrastructure with Terraform...${NC}"
cd terraform

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -out=plan.tfplan

# Apply configuration
terraform apply -auto-approve plan.tfplan

# Get ACR details
ACR_NAME=$(terraform output -raw container_registry_url)
ACR_USERNAME=$(az acr credential show --name $(echo $ACR_NAME | cut -d'.' -f1) --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show --name $(echo $ACR_NAME | cut -d'.' -f1) --query "passwords[0].value" -o tsv)

cd ..

# Tag and push image to ACR
echo -e "${YELLOW}📤 Pushing image to Azure Container Registry...${NC}"
docker tag nginx-webapp:latest $ACR_NAME/nginx-webapp:latest
echo $ACR_PASSWORD | docker login $ACR_NAME -u $ACR_USERNAME --password-stdin
docker push $ACR_NAME/nginx-webapp:latest

# Get the application URL
cd terraform
APP_URL=$(terraform output -raw webapp_url)

echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "${GREEN}🌐 Your Nginx web application is available at: ${APP_URL}${NC}"
echo -e "${YELLOW}📊 You can also check: ${APP_URL}/health for health status${NC}"
echo -e "${YELLOW}🔍 And: ${APP_URL}/api/info for container information${NC}"