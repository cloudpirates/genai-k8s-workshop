#!/usr/bin/env bash
set -euo pipefail

echo "=== Pre-pulling images for the workshop ==="
echo "This saves time during exercises by downloading images ahead of time."
echo ""

IMAGES=(
  "vllm/vllm-openai:latest"
  "docker.io/kserve/huggingfaceserver:latest"
)

for img in "${IMAGES[@]}"; do
  echo "Pulling $img ..."
  docker pull "$img" || echo "⚠️  Failed to pull $img — will be pulled during exercises"
done

echo ""
echo "=== Pre-pull complete ==="
echo "Images cached locally. They'll be loaded into kind automatically when needed."
