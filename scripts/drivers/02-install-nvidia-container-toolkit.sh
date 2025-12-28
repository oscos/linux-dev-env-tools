#!/usr/bin/env bash
set -e

echo "=== Installing NVIDIA Container Toolkit (GPU support for Docker) ==="

# 0️⃣ Wait for PackageKit / other apt processes to finish
echo "--- Waiting for other package managers to finish..."
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 || sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do
    echo "Another package manager is running (PackageKit / apt). Waiting 5s..."
    sleep 5
done

# 1️⃣ Clean up any old / broken repo lists
sudo rm -f /etc/apt/sources.list.d/libnvidia-container.list
sudo rm -f /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 2️⃣ Install prerequisites
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# 3️⃣ Add NVIDIA GPG key to keyring
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
    sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-container-toolkit.gpg
sudo chmod a+r /etc/apt/keyrings/nvidia-container-toolkit.gpg

# 4️⃣ Add the generic stable Ubuntu repo for NVIDIA Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 5️⃣ Fix the .list file to use the signed key
sudo sed -i 's#deb https://#deb [signed-by=/etc/apt/keyrings/nvidia-container-toolkit.gpg] https://#' \
    /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 6️⃣ Update package index
sudo apt-get update -y

# 7️⃣ Install the NVIDIA container toolkit
sudo apt-get install -y nvidia-container-toolkit

# 8️⃣ Configure Docker runtime for NVIDIA
sudo nvidia-ctk runtime configure --runtime=docker

# 9️⃣ Restart Docker daemon
sudo systemctl restart docker

# 🔟 Test GPU inside Docker
echo ""
echo "--- Testing GPU access inside Docker ---"
echo "docker run --rm --gpus all nvidia/cuda:13.0.1-base-ubuntu22.04 nvidia-smi"
docker run --rm --gpus all nvidia/cuda:13.0.1-base-ubuntu22.04 nvidia-smi || {
    echo "⚠️ GPU test failed. Try rebooting and running nvidia-smi on the host first."
}

echo ""
echo "=== NVIDIA Docker setup complete! ==="

