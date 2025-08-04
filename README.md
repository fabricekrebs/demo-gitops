# GitOps Demo

This repository demonstrates GitOps practices by managing Kubernetes application deployments using Flux. It automatically syncs and deploys applications to an AKS cluster whenever changes are made to this repository.

## Applications

- **aks-demo-webapp**: Custom webapp demo
- **aks-store-demo**: Microservices e-commerce demo

## Usage

1. Configure Flux to watch this repository
2. Push changes to trigger automatic deployments
3. Flux will sync applications to your AKS cluster
