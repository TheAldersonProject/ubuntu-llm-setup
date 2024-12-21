#!/bin/bash
# scripts/02_nvidia_setup.sh
set -e

echo "Installing NVIDIA drivers and CUDA..."
apt install -y nvidia-driver-525 nvidia-cuda-toolkit

# Copy NVIDIA configurations
cp config/nvidia/nvidia-power.conf /etc/modprobe.d/

# Configure NVIDIA settings
nvidia-smi -pm 1
nvidia-smi --auto-boost-default=0
nvidia-smi -ac 5001,1590

echo "Testing NVIDIA installation..."
nvidia-smi

echo "NVIDIA setup complete!"
