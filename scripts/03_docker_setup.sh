#!/bin/bash
# scripts/03_docker_setup.sh
set -e

echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Add current user to docker group
usermod -aG docker $USER

# Install Docker Compose
apt install -y docker-compose

# Copy Docker configurations
cp config/docker/daemon.json /etc/docker/

# Create docker network
docker network create llm-network

# Start and enable Docker
systemctl enable docker
systemctl start docker

echo "Docker setup complete!"
