# GitOps Demo

This repository demonstrates GitOps practices by managing Kubernetes application deployments using Flux. It automatically syncs and deploys applications to an AKS cluster whenever changes are made to this repository.

## Applications

- **aks-demo-webapp**: Custom webapp demo
- **aks-store-demo**: Microservices e-commerce demo  
- **aks-azure-files-demo**: Azure Files PVC demo for backup testing (from separate repo)

## Usage

1. Configure Flux to watch this repository
2. Push changes to trigger automatic deployments
3. Flux will sync applications to your AKS cluster

## Azure Files Demo

The `aks-azure-files-demo` application is managed from a separate repository at `https://github.com/fabricekrebs/aks-azure-files-demo`. It's specifically designed for testing Azure Files integration and backup scenarios. It includes:

- **Persistent Volume Claim** using Azure Files CSI driver
- **Continuous data generation** for backup testing
- **Web interface** for monitoring file operations
- **Multiple data types** (logs, uploads, test files) for comprehensive backup testing

Access the application at `http://aks-azure-files-demo.local` (via ingress) or use port-forwarding:

```bash
kubectl port-forward -n aks-azure-files-demo service/azure-files-demo-service 8080:80
```

The manifests for this application are maintained in the separate `aks-azure-files-demo` repository.
