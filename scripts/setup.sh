#!/usr/bin/env bash
set -euo pipefail

echo "=== Generative AI in Kubernetes Workshop Setup ==="
echo ""

# Check prerequisites
check_cmd() {
  if ! command -v "$1" &>/dev/null; then
    echo "❌ $1 not found. Please install it first."
    echo "   $2"
    exit 1
  else
    echo "✅ $1 found: $(command -v "$1")"
  fi
}

check_cmd docker "https://docs.docker.com/get-docker/"
check_cmd kubectl "https://kubernetes.io/docs/tasks/tools/"
check_cmd kind "https://kind.sigs.k8s.io/docs/user/quick-start/#installation"
check_cmd helm "https://helm.sh/docs/intro/install/"
check_cmd curl "Install via your package manager"
check_cmd jq "Install via your package manager"

echo ""
echo "=== Creating Kind cluster ==="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Delete existing cluster if it exists
kind delete cluster --name genai-workshop 2>/dev/null || true

# Create cluster
kind create cluster --name genai-workshop \
  --config "$REPO_DIR/exercises/01-kind-cluster/kind-config.yaml"

echo ""
echo "=== Cluster created ==="
kubectl get nodes
echo ""

echo "=== Installing cert-manager ==="
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.3/cert-manager.yaml
echo "Waiting for cert-manager..."
kubectl wait --for=condition=Available deployment --all -n cert-manager --timeout=120s
echo "✅ cert-manager ready"

echo ""
echo "=== Installing KServe ==="
kubectl apply -f https://github.com/kserve/kserve/releases/download/v0.14.1/kserve.yaml
kubectl apply -f https://github.com/kserve/kserve/releases/download/v0.14.1/kserve-cluster-resources.yaml
echo "Waiting for KServe..."
kubectl wait --for=condition=Available deployment --all -n kserve --timeout=180s || echo "⚠️  KServe may still be starting up"
echo "✅ KServe installed"

echo ""
echo "=== Installing fake-gpu-operator ==="
helm repo add fake-gpu-operator https://fake-gpu-operator.storage.googleapis.com 2>/dev/null || true
helm repo update fake-gpu-operator
helm install fake-gpu-operator fake-gpu-operator/fake-gpu-operator \
  --namespace gpu-operator --create-namespace \
  --set topology.nodes[0].gpuModel=A100 \
  --set topology.nodes[0].gpuCount=4 \
  --set topology.nodes[0].nodeLabels."nvidia\.com/gpu\.product"=A100
echo "Waiting for fake-gpu-operator..."
kubectl wait --for=condition=Available deployment --all -n gpu-operator --timeout=120s || echo "⚠️  fake-gpu-operator may still be starting"
echo "✅ fake-gpu-operator installed (4x A100 per node)"

echo ""
echo "=== Installing Gateway API Inference Extension CRDs ==="
kubectl apply -f "$REPO_DIR/exercises/05-gateway/crds.yaml"
echo "✅ Inference Extension CRDs installed"

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Nodes:"
kubectl get nodes
echo ""
echo "Next: Run the exercises in order (see README.md)"
