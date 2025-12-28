#!/usr/bin/env bash
set -e

echo "=== Installing Official Docker Engine (Docker CE) ==="

# Ensure required packages are installed
echo "--- Installing prerequisite packages..."
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Create directory for Docker apt key
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker’s official GPG key
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    echo "--- Adding Docker GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
else
    echo "--- Docker GPG key already exists, skipping."
fi

# Add Docker repository
echo "--- Adding Docker APT repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
sudo apt-get update -y

# Install Docker Engine
echo "--- Installing Docker CE + CLI + containerd..."
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Ensure Docker daemon is enabled and started
echo "--- Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group
echo "--- Adding user '$USER' to docker group..."
sudo usermod -aG docker "$USER"

echo "=== Docker installation complete! ==="
echo ""

# Test Docker if daemon is active
echo "--- Running Docker hello-world test (may require log out/in)..."
if docker run --rm hello-world; then
    echo "=== Docker is working correctly! ==="
else
    echo "=== Docker installed, but hello-world failed."
    echo "You may need to log out and back in for group membership to apply."
fi
