#!/bin/bash

# Check the status of GitOps deployments
# This script provides an overview of all Flux-managed resources

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}📊 GitOps Deployment Status${NC}"
echo "================================="

# Check if kubectl is available
if ! kubectl cluster-info > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: kubectl is not configured or cluster is not accessible${NC}"
    exit 1
fi

# Check if flux CLI is installed
if ! command -v flux &> /dev/null; then
    echo -e "${YELLOW}⚠️  Warning: flux CLI is not installed. Using kubectl only.${NC}"
    FLUX_AVAILABLE=false
else
    FLUX_AVAILABLE=true
fi

echo ""
echo -e "${BLUE}🔧 Flux System Status:${NC}"
if [ "$FLUX_AVAILABLE" = true ]; then
    flux get all -n flux-system
else
    kubectl get pods -n flux-system
fi

echo ""
echo -e "${BLUE}📱 Application Namespaces:${NC}"
kubectl get namespaces | grep -E "(demo-webapp|aks-store-demo)" || echo "No application namespaces found"

echo ""
echo -e "${BLUE}🚀 Demo WebApp Status:${NC}"
if kubectl get namespace demo-webapp > /dev/null 2>&1; then
    kubectl get pods -n demo-webapp
    echo ""
    kubectl get services -n demo-webapp
else
    echo "demo-webapp namespace not found"
fi

echo ""
echo -e "${BLUE}🏪 AKS Store Demo Status:${NC}"
if kubectl get namespace aks-store-demo > /dev/null 2>&1; then
    kubectl get pods -n aks-store-demo
    echo ""
    kubectl get services -n aks-store-demo
else
    echo "aks-store-demo namespace not found"
fi

echo ""
echo -e "${BLUE}🌐 Ingress Controller Status:${NC}"
if kubectl get namespace ingress-nginx > /dev/null 2>&1; then
    kubectl get pods -n ingress-nginx
    echo ""
    kubectl get services -n ingress-nginx
else
    echo "ingress-nginx namespace not found"
fi

if [ "$FLUX_AVAILABLE" = true ]; then
    echo ""
    echo -e "${BLUE}🔄 Flux Sources:${NC}"
    flux get sources all -A
    
    echo ""
    echo -e "${BLUE}📦 Flux Kustomizations:${NC}"
    flux get kustomizations -A
fi

echo ""
echo -e "${YELLOW}💡 Useful Commands:${NC}"
echo "• Check Flux status: flux get all -A"
echo "• Monitor deployments: watch kubectl get pods -A"
echo "• View logs: kubectl logs -n <namespace> <pod-name>"
echo "• Force reconciliation: flux reconcile kustomization <name> -n <namespace>"
