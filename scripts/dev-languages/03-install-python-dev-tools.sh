#!/bin/bash
set -e

echo "=============================================="
echo " Installing Python Development Tools for Pop!_OS"
echo "=============================================="

# Update package lists
echo "[1/6] Updating package lists..."
sudo apt update -y

# Install pip and venv support
echo "[2/6] Installing python3-pip and python3-venv..."
sudo apt install -y python3-pip python3-venv

# Install pipx (isolated global tool installer)
echo "[3/6] Installing pipx..."
sudo apt install -y pipx
pipx ensurepath

# Export updated PATH for current shell session
export PATH="$PATH:$HOME/.local/bin"

# Install or upgrade Poetry using pipx
echo "[4/6] Installing or upgrading Poetry using pipx..."
if pipx list | grep -q poetry; then
    echo "Poetry already installed — upgrading..."
    pipx upgrade poetry
else
    echo "Poetry not found — installing..."
    pipx install poetry
fi

# Configure Poetry (recommended best practices)
echo "[5/6] Configuring Poetry settings..."
# Keep virtualenvs outside project directories
poetry config virtualenvs.in-project false

# Install pre-commit as global CLI tool
echo "[6/6] Installing pre-commit..."
if pipx list | grep -q pre-commit; then
    echo "pre-commit already installed — upgrading..."
    pipx upgrade pre-commit
else
    echo "pre-commit not found — installing..."
    pipx install pre-commit
fi

echo "=============================================="
echo " Python development tools installation complete!"
echo "=============================================="
echo
echo " Installed tools:"
echo "   ✔ pip3"
echo "   ✔ python3-venv"
echo "   ✔ pipx"
echo "   ✔ poetry"
echo "   ✔ pre-commit"
echo
echo "Next steps:"
echo "  • Restart your terminal OR run: source ~/.profile"
