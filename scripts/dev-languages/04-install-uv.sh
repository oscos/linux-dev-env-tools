#!/usr/bin/env bash
set -e

echo "=============================================="
echo " Installing 'uv' - Modern Python Package Manager"
echo "=============================================="

# Check if uv is already installed
if command -v uv &> /dev/null; then
    echo "uv is already installed - skipping."
    uv --version
    exit 0
fi

# Download and install uv (system-wide)
echo "Downloading and installing uv..."
# curl -sSf https://install.astral.sh | sh
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify installation
if command -v uv &> /dev/null; then
    echo "uv installed successfully!"
    uv --version
else
    echo "ERROR: uv installation failed."
    exit 1
fi

echo "=============================================="
echo " 'uv' installation complete!"
echo "=============================================="

