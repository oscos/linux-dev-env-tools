#!/usr/bin/env bash
set -e

echo "=== Installing Terraform (HashiCorp Official) ==="

# ----------------------------
# Variables
# ----------------------------
HASHICORP_GPG_KEY="/etc/apt/keyrings/hashicorp.gpg"
HASHICORP_KEYRING_DIR="/etc/apt/keyrings"
HASHICORP_REPO_FILE="/etc/apt/sources.list.d/hashicorp.list"

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
echo "--- Ensuring HashiCorp GPG key exists..."
sudo install -m 0755 -d "$HASHICORP_KEYRING_DIR"

if [ ! -f "$HASHICORP_GPG_KEY" ]; then
    echo "--- Adding HashiCorp GPG key..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | \
        sudo gpg --dearmor -o "$HASHICORP_GPG_KEY"
    sudo chmod a+r "$HASHICORP_GPG_KEY"
else
    echo "--- HashiCorp GPG key already exists, skipping."
fi

# ----------------------------
# HashiCorp APT Repository
# ----------------------------
if [ ! -f "$HASHICORP_REPO_FILE" ]; then
    echo "--- Adding HashiCorp APT repository..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=$HASHICORP_GPG_KEY] \
      https://apt.releases.hashicorp.com \
      $(lsb_release -cs) main" | \
      sudo tee "$HASHICORP_REPO_FILE" > /dev/null
else
    echo "--- HashiCorp APT repository already exists, skipping."
fi

# ----------------------------
# Install Terraform
# ----------------------------
echo "--- Updating package index..."
sudo apt-get update -y

echo "--- Installing Terraform..."
sudo apt-get install -y terraform

# ----------------------------
# Validation
# ----------------------------
echo ""
echo "=== Terraform installation complete! ==="
echo ""

terraform version
