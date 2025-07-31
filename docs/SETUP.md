# GitOps Setup and Management Guide

## Overview

This guide provides detailed instructions for setting up and managing the GitOps workflow for AKS using Flux.

## Prerequisites

1. **AKS Cluster**: A running Azure Kubernetes Service cluster
2. **kubectl**: Configured to connect to your AKS cluster
3. **Flux CLI**: Installed on your local machine
4. **GitHub Personal Access Token**: With repository permissions
5. **Azure CLI**: For AKS management (optional)

## Installation Steps

### 1. Install Flux CLI

```bash
# On Linux/macOS
curl -s https://fluxcd.io/install.sh | sudo bash

# On Windows (using PowerShell)
Invoke-WebRequest -Uri https://github.com/fluxcd/flux2/releases/latest/download/flux_windows_amd64.zip -OutFile flux.zip
Expand-Archive flux.zip -DestinationPath .
Move-Item flux.exe C:\Windows\System32\
```

### 2. Set up GitHub Token

```bash
export GITHUB_TOKEN=<your-personal-access-token>
```

### 3. Bootstrap Flux

Use the provided script:

```bash
./scripts/bootstrap-flux.sh
```

Or run manually:

```bash
flux bootstrap github \
  --owner=fabricekrebs \
  --repository=demo-gitops \
  --branch=main \
  --path=clusters/production \
  --personal
```

## Repository Structure Explained

```
demo-gitops/
├── clusters/production/           # Cluster-specific configurations
│   ├── flux-system.yaml          # Main Flux configuration
│   └── kustomization.yaml        # Cluster kustomization
├── apps/                          # Application definitions
│   ├── aks-demo-webapp/          # Demo webapp configuration
│   │   ├── aks-demo-webapp.yaml  # Flux resources for demo-webapp
│   │   └── kustomization.yaml    # App kustomization
│   ├── aks-store-demo/           # AKS store demo configuration
│   │   ├── aks-store-demo.yaml   # Flux resources for store demo
│   │   └── kustomization.yaml    # App kustomization
│   └── kustomization.yaml        # Apps directory kustomization
├── rbac.yaml                     # Flux RBAC permissions
├── namespaces.yaml               # Application namespaces
├── kustomization.yaml            # Root kustomization
└── scripts/                      # Helper scripts
    ├── bootstrap-flux.sh         # Flux bootstrap script
    └── check-status.sh           # Status checking script
```

## Application Management

### AKS Demo WebApp

- **Source Repository**: https://github.com/fabricekrebs/demo-webapp
- **Namespace**: aks-demo-webapp
- **Manifests Path**: ./manifests
- **Sync Interval**: 10 minutes

### AKS Store Demo

- **Source Repository**: https://github.com/Azure-Samples/aks-store-demo
- **Namespace**: aks-store-demo
- **Manifests Path**: ./kustomize/base
- **Sync Interval**: 10 minutes

## Common Operations

### Check Deployment Status

```bash
# Use the provided script
./scripts/check-status.sh

# Or check manually
flux get all -A
kubectl get pods -A
```

### Force Reconciliation

```bash
# Reconcile everything from root
flux reconcile kustomization demo-gitops -n flux-system

# Reconcile specific application
flux reconcile kustomization aks-demo-webapp -n flux-system
flux reconcile kustomization aks-store-demo -n flux-system
```

### View Logs

```bash
# Flux controller logs
kubectl logs -n flux-system deployment/source-controller
kubectl logs -n flux-system deployment/kustomize-controller

# Application logs
kubectl logs -n aks-demo-webapp -l app=aks-demo-webapp
kubectl logs -n aks-store-demo -l app=store-front
```

### Suspend/Resume Deployments

```bash
# Suspend an application
flux suspend kustomization aks-demo-webapp -n flux-system

# Resume an application
flux resume kustomization aks-demo-webapp -n flux-system
```

## Troubleshooting

### Common Issues

1. **GitRepository not syncing**
   ```bash
   flux get sources git -A
   kubectl describe gitrepository -n <namespace> <name>
   ```

2. **Kustomization failing**
   ```bash
   flux get kustomizations -A
   kubectl describe kustomization -n <namespace> <name>
   ```

3. **Pods not starting**
   ```bash
   kubectl get pods -n <namespace>
   kubectl describe pod -n <namespace> <pod-name>
   kubectl logs -n <namespace> <pod-name>
   ```

### Debug Commands

```bash
# Check Flux system health
flux check

# Get detailed status
flux get all -A --status-selector ready=false

# Export resources for debugging
flux export source git aks-demo-webapp-source -n flux-system
flux export kustomization aks-demo-webapp -n flux-system
```

## Customization

### Adding New Applications

1. Create a new directory under `apps/`
2. Add the application's Flux resources
3. Update the main `apps/kustomization.yaml`
4. Commit and push changes

### Environment-Specific Configurations

To add staging environment:

1. Create `clusters/staging/`
2. Copy and modify production configurations
3. Adjust namespaces and resource specifications
4. Update application configurations for staging

### Advanced Configurations

- **Image Automation**: Configure automatic image updates
- **Notifications**: Set up Slack/Teams alerts
- **Multi-tenancy**: Implement tenant isolation
- **Progressive Delivery**: Add Flagger for canary deployments

## Security Best Practices

1. **RBAC**: Cross-namespace permissions configured for Flux controllers
2. **Network Policies**: Restrict pod-to-pod communication
3. **Secrets Management**: Use Azure Key Vault or Sealed Secrets
4. **Image Scanning**: Implement container vulnerability scanning
5. **Git Security**: Use signed commits and branch protection

### Flux RBAC Configuration

The repository includes a simple RBAC configuration (`rbac.yaml`) that grants the `flux-applier` service account cluster-wide permissions:

- **ClusterRole**: `flux-applier-cluster-role` with full permissions
- **ClusterRoleBinding**: Binds the `flux-applier` service account to the cluster role
- **Broad Permissions**: Allows Flux to manage all resources across all namespaces

This ensures Flux can deploy applications anywhere while keeping the configuration simple.

## Monitoring and Observability

### Metrics

- Flux exports metrics to Prometheus
- Monitor reconciliation status and drift detection
- Set up alerts for failed deployments

### Logging

- Centralize logs using Azure Monitor or ELK stack
- Monitor application and infrastructure logs
- Set up log-based alerts

## Backup and Disaster Recovery

1. **Git Repository**: Primary source of truth
2. **Cluster State**: Regular etcd backups
3. **Persistent Data**: Azure Disk/File backups
4. **Recovery Procedures**: Document restoration steps

## Additional Resources

- [Flux Documentation](https://fluxcd.io/docs/)
- [Kustomize Reference](https://kustomize.io/)
- [AKS Best Practices](https://docs.microsoft.com/en-us/azure/aks/)
- [GitOps Guide](https://www.gitops.tech/)
