#!/usr/bin/env bash
set -e

echo "=============================================="
echo " Installing 'uv' - Modern Python Package Manager"
echo "=============================================="

# ----------------------------
# Ensure ~/.local/bin exists
# ----------------------------
mkdir -p "$HOME/.local/bin"

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

# ----------------------------
# Refresh PATH for current shell
# ----------------------------
export PATH="$PATH:$HOME/.local/bin"

# Verify installation
if command -v uv &> /dev/null; then
    echo "uv installed successfully!"
    uv --version
else
    echo "ERROR: uv installation failed."
    echo "Try restarting your terminal or running:"
    echo "  source ~/.profile"
    exit 1
fi

echo "=============================================="
echo " 'uv' installation complete!"
echo "=============================================="
echo
echo "Next steps:"
echo "  • Restart your terminal OR run: source ~/.profile"
echo
