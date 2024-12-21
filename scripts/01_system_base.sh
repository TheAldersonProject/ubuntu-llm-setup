#!/bin/bash
# scripts/01_system_base.sh
set -e

echo "Installing base system packages..."
apt update && apt upgrade -y
apt install -y \
    build-essential \
    git \
    curl \
    wget \
    htop \
    neofetch \
    net-tools \
    ufw \
    fail2ban \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Set timezone
timedatectl set-timezone America/Sao_Paulo

# Copy system configurations
cp config/system/sysctl.conf /etc/sysctl.d/99-legion-optimization.conf
cp config/system/limits.conf /etc/security/limits.d/99-legion-limits.conf

# Apply system settings
sysctl --system

echo "Base system setup complete!"
