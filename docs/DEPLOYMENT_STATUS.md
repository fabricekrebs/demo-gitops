# Deployment Configuration

## Application Versions

| Application | Repository | Branch | Path | Namespace | Status |
|-------------|------------|--------|------|-----------|---------|
| AKS Demo WebApp | fabricekrebs/demo-webapp | main | ./manifests | aks-demo-webapp | Configured |
| AKS Store Demo | Azure-Samples/aks-store-demo | main | ./kustomize/base | aks-store-demo | Configured |

## Infrastructure Components

| Component | Status | Notes |
|-----------|--------|-------|
| Flux System | Configured | Main GitOps controller |
| Ingress NGINX | Configured | Load balancer ingress |

## Environment Configuration

### Production Cluster
- **Cluster Path**: `clusters/production`
- **Branch**: `main`
- **Sync Interval**: 10 minutes
- **Prune**: Enabled
- **Validation**: Client-side

### Namespace Configuration

- **aks-demo-webapp**: Dedicated namespace for the custom Django application
- **aks-store-demo**: Dedicated namespace for the microservices demo
- **ingress-nginx**: Nginx ingress controller
- **flux-system**: Flux controllers and configurations

## Security Settings

- **Network Policies**: To be configured
- **RBAC**: Default service account permissions
- **Secret Management**: In-cluster secrets (consider Azure Key Vault integration)

## Monitoring & Observability

- **Metrics**: Flux built-in metrics
- **Logging**: Kubernetes default logging
- **Alerts**: To be configured

## Backup Strategy

- **Git Repository**: Primary backup through GitHub
- **Cluster State**: Manual kubectl exports
- **Persistent Data**: Application-specific backup procedures

## Next Steps

1. ✅ Repository structure created
2. ✅ Flux configurations defined
3. ✅ Application sources configured
4. ✅ Infrastructure components added
5. ✅ Helper scripts created
6. ✅ Documentation written
7. ⏳ Bootstrap Flux on AKS cluster
8. ⏳ Verify application deployments
9. ⏳ Configure monitoring and alerts
10. ⏳ Implement security policies
