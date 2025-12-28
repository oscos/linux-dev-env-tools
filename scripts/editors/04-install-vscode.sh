#!/usr/bin/env bash

set -e  # exit if any command fails

echo "=== Installing Visual Studio Code ==="

# ---------------------------------------------------------
# 1. Install dependencies required for adding repositories
# ---------------------------------------------------------
sudo apt update
sudo apt install -y wget gpg apt-transport-https

# ---------------------------------------------------------
# 2. Add Microsoft GPG key (if not already installed)
#    We check so it's idempotent.
# ---------------------------------------------------------
if ! gpg --list-keys | grep -q "Microsoft (Release signing)"; then
    echo "Adding Microsoft GPG key..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor \
        | sudo tee /usr/share/keyrings/vscode.gpg > /dev/null
else
    echo "Microsoft GPG key already installed."
fi

# ---------------------------------------------------------
# 3. Add VS Code repository (if not already present)
# ---------------------------------------------------------
if ! grep -q "packages.microsoft.com/repos/code" /etc/apt/sources.list.d/vscode.list 2>/dev/null; then
    echo "Adding VS Code repository..."
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" \
        | sudo tee /etc/apt/sources.list.d/vscode.list
else
    echo "VS Code repository already exists."
fi

# ---------------------------------------------------------
# 4. Install VS Code
# ---------------------------------------------------------
sudo apt update
sudo apt install -y code

echo "=== VS Code installed ==="

# ---------------------------------------------------------
# 5. Install recommended extensions
# ---------------------------------------------------------
echo "=== Installing VS Code extensions ==="

EXTENSIONS=(
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
    ms-toolsai.jupyter-keymap
    ms-toolsai.jupyter-renderers
    ms-toolsai.datawrangler
    ms-vscode.makefile-tools
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-containers
    ms-vscode.live-server
    njpwerner.autodocstring
    eamodio.gitlens
    vscode-icons-team.vscode-icons
)

for ext in "${EXTENSIONS[@]}"; do
    if code --list-extensions | grep -q "$ext"; then
        echo "[skip] $ext already installed"
    else
        echo "Installing extension: $ext"
        code --install-extension "$ext"
    fi
done

echo "=== VS Code setup complete! ==="
