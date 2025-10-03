#!/usr/bin/env bash
# infra/cloudrun/deploy-openwebui.sh
# Cloud Run deploy one-liner (idempotent)
set -euo pipefail

PROJECT=${PROJECT_ID:-kernel-o6}
REGION=${REGION:-us-central1}
SERVICE=${SERVICE:-openwebui}
IMAGE=ghcr.io/open-webui/open-webui:main

echo "Deploying Open WebUI to Cloud Run..."
echo "Project: $PROJECT"
echo "Region: $REGION"
echo "Service: $SERVICE"

# Set project
gcloud config set project $PROJECT

# Create buckets if they don't exist
echo "Creating Cloud Storage buckets..."
gsutil mb -l $REGION gs://central-servers-data/ || echo "Bucket central-servers-data already exists"
gsutil mb -l $REGION gs://central-servers-uploads/ || echo "Bucket central-servers-uploads already exists"

# Deploy to Cloud Run with volume mounts
echo "Deploying to Cloud Run..."
gcloud run deploy $SERVICE \
  --image=$IMAGE \
  --region=$REGION \
  --allow-unauthenticated \
  --add-volume name=data,type=cloud-storage,bucket=central-servers-data \
  --add-volume-mount volume=data,mount-path=/app/backend/data \
  --add-volume name=uploads,type=cloud-storage,bucket=central-servers-uploads \
  --add-volume-mount volume=uploads,mount-path=/app/backend/uploads

echo "Deployment complete!"
echo "Service URL: $(gcloud run services describe $SERVICE --region=$REGION --format='value(status.url)')"
