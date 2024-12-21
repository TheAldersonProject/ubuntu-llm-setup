#!/bin/bash
# scripts/04_python_setup.sh
set -e

echo "Installing Python 3.12..."
add-apt-repository ppa:deadsnakes/ppa -y
apt update
apt install -y python3.12 python3.12-venv python3.12-dev

# Create development directory
mkdir -p ~/llm-dev
cd ~/llm-dev

# Create virtual environment
python3.12 -m venv .venv
source .venv/bin/activate

# Install development packages
pip install --upgrade pip
pip install \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 \
    transformers \
    accelerate \
    bitsandbytes \
    scipy \
    numpy \
    pandas \
    matplotlib \
    jupyterlab

echo "Python setup complete!"
