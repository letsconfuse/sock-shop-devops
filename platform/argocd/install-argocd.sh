#!/usr/bin/env bash
# install-argocd.sh - Bootstrap Argo CD and deploy the application

set -euo pipefail

ARGOCD_VERSION="v2.11.0"
ARGOCD_NAMESPACE="argocd"
APP_MANIFEST="platform/argocd/application.yaml"

echo "Initializing Argo CD installation (version: ${ARGOCD_VERSION})..."

# Check if kubectl is available
if ! command -v kubectl &>/dev/null; then
  echo "Error: kubectl is not installed or not in PATH." >&2
  exit 1
fi

# Create the namespace if it doesn't exist
if ! kubectl get namespace "${ARGOCD_NAMESPACE}" &>/dev/null; then
  echo "Creating namespace ${ARGOCD_NAMESPACE}..."
  kubectl create namespace "${ARGOCD_NAMESPACE}"
else
  echo "Namespace ${ARGOCD_NAMESPACE} already exists."
fi

# Apply the stable Argo CD installation manifests
echo "Applying Argo CD installation manifests..."
kubectl apply -n "${ARGOCD_NAMESPACE}" -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

# Wait for Argo CD components to be rolled out and ready
echo "Waiting for Argo CD deployments to be ready..."
deployments=(
  "argocd-redis"
  "argocd-repo-server"
  "argocd-server"
  "argocd-applicationset-controller"
  "argocd-notifications-controller"
)

for deploy in "${deployments[@]}"; do
  echo "Waiting for rollout of deployment/${deploy}..."
  kubectl rollout status "deployment/${deploy}" -n "${ARGOCD_NAMESPACE}" --timeout=150s
done

echo "Argo CD has been successfully installed and is running."

# Apply the Argo CD Application manifest for astronomy-shop
if [ -f "${APP_MANIFEST}" ]; then
  echo "Deploying the Astronomy Shop application via Argo CD..."
  kubectl apply -f "${APP_MANIFEST}"
  echo "Application manifest applied. Monitor status via kubectl or the Argo CD UI."
else
  echo "Warning: Application manifest not found at ${APP_MANIFEST}. Skipping application deployment."
fi
