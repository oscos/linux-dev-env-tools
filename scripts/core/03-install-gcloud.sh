#!/usr/bin/env bash
set -e

echo "=== Installing Google Cloud CLI (gcloud) ==="

# ----------------------------
# Variables
# ----------------------------
GCLOUD_KEYRING_DIR="/etc/apt/keyrings"
GCLOUD_GPG_KEY="/etc/apt/keyrings/cloud.google.gpg"
GCLOUD_REPO_FILE="/etc/apt/sources.list.d/google-cloud-sdk.list"

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
# Keyring Directory
# ----------------------------
echo "--- Ensuring keyring directory exists..."
sudo install -m 0755 -d "$GCLOUD_KEYRING_DIR"

# ----------------------------
# GPG Key
# ----------------------------
if [ ! -f "$GCLOUD_GPG_KEY" ]; then
    echo "--- Adding Google Cloud GPG key..."
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
        sudo gpg --dearmor -o "$GCLOUD_GPG_KEY"
    sudo chmod a+r "$GCLOUD_GPG_KEY"
else
    echo "--- Google Cloud GPG key already exists, skipping."
fi

# ----------------------------
# Google Cloud APT Repository
# ----------------------------
if [ ! -f "$GCLOUD_REPO_FILE" ]; then
    echo "--- Adding Google Cloud SDK APT repository..."
    echo \
      "deb [signed-by=$GCLOUD_GPG_KEY] \
      https://packages.cloud.google.com/apt \
      cloud-sdk main" | \
      sudo tee "$GCLOUD_REPO_FILE" > /dev/null
else
    echo "--- Google Cloud SDK APT repository already exists, skipping."
fi

# ----------------------------
# Install gcloud
# ----------------------------
echo "--- Updating package index..."
sudo apt-get update -y

echo "--- Installing Google Cloud CLI..."
sudo apt-get install -y google-cloud-cli

# ----------------------------
# Validation
# ----------------------------
echo ""
echo "=== Google Cloud CLI installation complete! ==="
echo ""

gcloud --version

