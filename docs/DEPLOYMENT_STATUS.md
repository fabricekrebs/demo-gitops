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
| RBAC | Configured | flux-applier permissions |
| Namespaces | Configured | Application namespaces |

## Environment Configuration

### Production Cluster
- **Cluster Path**: `clusters/production`
- **Branch**: `main`
- **Sync Interval**: 10 minutes
- **Prune**: Enabled
- **Root Path**: `./` (simplified structure)

### Namespace Configuration

- **aks-demo-webapp**: Dedicated namespace for the custom Django application
- **aks-store-demo**: Dedicated namespace for the microservices demo
- **flux-system**: Flux controllers and configurations

## Security Settings

- **RBAC**: flux-applier service account with cluster-wide permissions
- **Service Account**: All kustomizations use flux-applier
- **Permissions**: Full cluster access for simplified management

## Monitoring & Observability

- **Metrics**: Flux built-in metrics
- **Logging**: Kubernetes default logging
- **Alerts**: To be configured

## Backup Strategy

- **Git Repository**: Primary backup through GitHub
- **Cluster State**: Manual kubectl exports
- **Persistent Data**: Application-specific backup procedures

## Next Steps

1. ✅ Repository structure simplified
2. ✅ Root-level kustomization created
3. ✅ RBAC permissions configured
4. ✅ Namespaces moved to root
5. ✅ Complex infrastructure removed
6. ✅ Documentation updated
7. ⏳ Bootstrap Flux on AKS cluster
8. ⏳ Verify application deployments
9. ⏳ Configure monitoring and alerts
10. ⏳ Implement security policies
