#!/usr/bin/env bash
set -e

echo "=== Installing Official Docker Engine (Docker CE) ==="

# ----------------------------
# Variables
# ----------------------------
DOCKER_GPG_KEY="/etc/apt/keyrings/docker.gpg"
DOCKER_KEYRING_DIR="/etc/apt/keyrings"
DOCKER_REPO_FILE="/etc/apt/sources.list.d/docker.list"

# ----------------------------
# Prerequisites
# ----------------------------
echo "--- Installing prerequisite packages..."
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# ----------------------------
# GPG Key
# ----------------------------
echo "--- Ensuring Docker GPG key exists..."
sudo install -m 0755 -d "$DOCKER_KEYRING_DIR"

if [ ! -f "$DOCKER_GPG_KEY" ]; then
    echo "--- Adding Docker GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o "$DOCKER_GPG_KEY"
    sudo chmod a+r "$DOCKER_GPG_KEY"
else
    echo "--- Docker GPG key already exists, skipping."
fi

# ----------------------------
# Docker APT Repository
# ----------------------------
if [ ! -f "$DOCKER_REPO_FILE" ]; then
    echo "--- Adding Docker APT repository..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=$DOCKER_GPG_KEY] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee "$DOCKER_REPO_FILE" > /dev/null
else
    echo "--- Docker APT repository already exists, skipping."
fi

# ----------------------------
# Install Docker
# ----------------------------
echo "--- Updating package index..."
sudo apt-get update -y

echo "--- Installing Docker Engine + CLI + containerd..."
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# ----------------------------
# Enable Docker
# ----------------------------
echo "--- Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# ----------------------------
# Docker Group
# ----------------------------
echo "--- Adding user '$USER' to docker group..."
sudo usermod -aG docker "$USER"

# ----------------------------
# Validation
# ----------------------------
echo ""
echo "=== Docker installation complete! ==="
echo ""

# if groups "$USER" | grep -q docker; then
#     echo "--- Running Docker hello-world test..."
#     docker run --rm hello-world && \
#         echo "=== Docker is working correctly! ==="
# else
#     echo "=== Docker installed successfully ==="
#     echo "Log out and back in, then run:"
#     echo "    docker run hello-world"
# fi

echo "Log out and back in (or run: newgrp docker), then run:"
echo "    docker run hello-world"
