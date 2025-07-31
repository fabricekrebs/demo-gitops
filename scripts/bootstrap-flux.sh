#!/bin/bash

# Bootstrap Flux on AKS cluster
# This script will install Flux and configure it to watch this GitOps repository

set -e

# Variables
GITHUB_OWNER="fabricekrebs"
GITHUB_REPO="demo-gitops"
GITHUB_BRANCH="main"
FLUX_NAMESPACE="flux-system"
CLUSTER_PATH="clusters/production"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Bootstrapping Flux on AKS cluster...${NC}"

# Check if kubectl is available and cluster is accessible
if ! kubectl cluster-info > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: kubectl is not configured or cluster is not accessible${NC}"
    echo "Please ensure you are connected to your AKS cluster"
    exit 1
fi

# Check if flux CLI is installed
if ! command -v flux &> /dev/null; then
    echo -e "${RED}❌ Error: flux CLI is not installed${NC}"
    echo "Please install flux CLI: https://fluxcd.io/flux/installation/"
    exit 1
fi

# Check if GitHub token is available
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${RED}❌ Error: GITHUB_TOKEN environment variable is not set${NC}"
    echo "Please set your GitHub personal access token:"
    echo "export GITHUB_TOKEN=<your-token>"
    exit 1
fi

echo -e "${YELLOW}📋 Configuration:${NC}"
echo "  GitHub Owner: $GITHUB_OWNER"
echo "  Repository: $GITHUB_REPO"
echo "  Branch: $GITHUB_BRANCH"
echo "  Cluster Path: $CLUSTER_PATH"
echo "  Flux Namespace: $FLUX_NAMESPACE"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Bootstrap cancelled"
    exit 1
fi

echo -e "${GREEN}🔧 Installing Flux on the cluster...${NC}"

# Bootstrap Flux
flux bootstrap github \
  --owner="$GITHUB_OWNER" \
  --repository="$GITHUB_REPO" \
  --branch="$GITHUB_BRANCH" \
  --path="$CLUSTER_PATH" \
  --personal \
  --components-extra=image-reflector-controller,image-automation-controller

echo -e "${GREEN}✅ Flux bootstrap completed!${NC}"
echo ""
echo -e "${YELLOW}📊 Checking Flux status...${NC}"
flux get all -A

echo ""
echo -e "${GREEN}🎉 GitOps setup completed successfully!${NC}"
echo ""
echo -e "${YELLOW}📝 Next steps:${NC}"
echo "1. Monitor the deployment: kubectl get pods -A"
echo "2. Check Flux status: flux get all -A"
echo "3. View application logs: kubectl logs -n <namespace> <pod-name>"
echo "4. Access applications through their services or ingresses"
