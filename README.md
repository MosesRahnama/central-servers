# central-servers

Operational repo for Open WebUI on Google Cloud Run.

## Overview

This repository implements a production-ready setup for Open WebUI deployed on Google Cloud Run with:

- **Two-branch workflow**: `main` (truth) + `work/active` (development)
- **Automated CI/CD**: GitHub Actions with toggleable execution
- **Cloud-native deployment**: Google Cloud Run with Cloud Storage persistence
- **Development guardrails**: Git hooks, CODEOWNERS, and branch protection
- **IDE integration**: VS Code and Cursor configuration

## Quick Start

### Prerequisites

- Google Cloud CLI (`gcloud`) installed and authenticated
- Project ID: `kernel-o6` (configured in deployment scripts)
- GitHub repository access

### Setup Checklist

- [x] Repository created with initial structure
- [x] Git hooks and automation scripts added
- [x] CI workflow configured (toggle via `CI_ENABLED` variable)
- [x] CODEOWNERS for automatic reviews
- [x] IDE configuration files
- [ ] Enable CI: Go to Settings → Variables → Add `CI_ENABLED=true`
- [ ] Create GCS buckets: `central-servers-data`, `central-servers-uploads`
- [ ] Deploy Open WebUI to Cloud Run
- [ ] Configure API endpoints and environment variables
- [ ] Create `work/active` branch for development

### Deployment

1. **Authenticate with Google Cloud**:
   ```bash
   gcloud auth login
   gcloud config set project kernel-o6
   ```

2. **Deploy Open WebUI**:
   ```bash
   bash infra/cloudrun/deploy-openwebui.sh
   ```

3. **Configure API endpoints** (example):
   ```bash
   gcloud run services update openwebui --region=us-central1 \
     --set-env-vars=OPENAI_API_BASE=https://openrouter.ai/api/v1 \
     --set-env-vars=OPENAI_API_KEY=<YOUR_KEY>
   ```

## Repository Structure

```
central-servers/
├─ infra/cloudrun/          # Cloud Run deployment scripts
├─ scripts/                 # Operational scripts
├─ docs/                    # Documentation and diagrams
├─ logs/                    # Agent audit logs
├─ .github/
│  ├─ workflows/           # GitHub Actions
│  └─ CODEOWNERS           # Auto-reviewer assignment
├─ .githooks/              # Local Git hooks
├─ .vscode/                # VS Code settings
├─ .cursor/rules/          # Cursor IDE rules
├─ README.md
└─ CHANGELOG.md
```

## Workflow

### Branching Strategy

- **`main`**: Production truth branch
- **`work/active`**: Long-running development branch
- **`task/*`**: Short-lived feature branches (deleted after merge)

### Development Process

1. Work in `work/active` or create `task/*` branches
2. Open Pull Requests to `main`
3. Automatic reviewer assignment via CODEOWNERS
4. CI checks run if `CI_ENABLED=true`
5. Merge after approval and green checks

## Monitoring & Operations

### View Logs
```bash
gcloud logs tail --project kernel-o6 --resource=cloud_run_revision --service=openwebui
```

### Check Service Status
```bash
gcloud run services describe openwebui --region=us-central1
```

### Rollback Deployment
```bash
gcloud run services update-traffic openwebui --to-revisions=REVISION=100
```

## Configuration

### Enable/Disable CI

Go to repository Settings → Variables → Repository variables:
- Set `CI_ENABLED=true` to enable automated checks
- Set `CI_ENABLED=false` to disable

### Environment Variables

Open WebUI supports various environment variables for configuration:
- `OPENAI_API_BASE`: API endpoint URL
- `OPENAI_API_KEY`: API authentication key
- See [Open WebUI documentation](https://docs.openwebui.com/getting-started/env-configuration/) for complete list

## Troubleshooting

### CI Not Running
- Verify `CI_ENABLED=true` in repository variables
- Check branch name matches workflow triggers

### Deployment Issues
- Ensure GCS buckets exist and are accessible
- Verify Cloud Run service has proper permissions
- Check Cloud Logging for runtime errors

### Data Persistence
- Confirm volume mounts: `/app/backend/data` and `/app/backend/uploads`
- Verify Cloud Storage buckets are properly mounted

For detailed troubleshooting, see the operations guide or check Cloud Logging.
