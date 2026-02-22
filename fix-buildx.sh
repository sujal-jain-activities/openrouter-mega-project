#!/usr/bin/env bash
set -e

echo "=== Fixing docker-buildx ==="

mkdir -p ~/.docker/cli-plugins

echo "Fetching latest buildx release tag..."
BUILDX_VERSION=$(curl -fsSL https://api.github.com/repos/docker/buildx/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
echo "Latest version: $BUILDX_VERSION"

echo "Downloading buildx for linux/amd64..."
curl -fsSL -o ~/.docker/cli-plugins/docker-buildx \
  "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64"

chmod +x ~/.docker/cli-plugins/docker-buildx

echo ""
echo "=== Verifying install ==="
docker buildx version

echo ""
echo "=== buildx fixed! Now running docker compose up --build ==="
