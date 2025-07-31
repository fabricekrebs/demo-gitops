# GitOps Repository for AKS Flux

This repository contains the GitOps configuration for deploying applications to Azure Kubernetes Service (AKS) using Flux.

## Repository Structure

```
├── clusters/production/       # Cluster-specific configurations
├── apps/                      # Application configurations
│   ├── aks-demo-webapp/       # Demo webapp application
│   └── aks-store-demo/        # AKS store demo application
├── rbac.yaml                  # Flux RBAC permissions
├── namespaces.yaml           # Application namespaces
├── kustomization.yaml        # Root kustomization
└── scripts/                  # Helper scripts
```

## Applications

### 1. AKS Demo WebApp
- **Source**: https://github.com/fabricekrebs/demo-webapp
- **Description**: Custom Django web application for demonstration purposes
- **Namespace**: aks-demo-webapp

### 2. AKS Store Demo
- **Source**: https://github.com/Azure-Samples/aks-store-demo
- **Description**: Microservices-based e-commerce application
- **Namespace**: aks-store-demo

## Getting Started

1. Configure Flux on your AKS cluster
2. Point Flux to this repository
3. Applications will be automatically deployed and managed by Flux

## Flux Bootstrap

To bootstrap Flux on your AKS cluster, run:

```bash
flux bootstrap github \
  --owner=fabricekrebs \
  --repository=demo-gitops \
  --branch=main \
  --path=clusters/production \
  --personal
```
