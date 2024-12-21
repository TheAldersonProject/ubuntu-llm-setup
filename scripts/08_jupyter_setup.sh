# scripts/08_jupyter_setup.sh
#!/bin/bash
set -e

echo "Setting up Jupyter environment..."

# Create jupyter config directory
mkdir -p ~/.jupyter

# Generate Jupyter config
jupyter server --generate-config

# Create SSL certificate for Jupyter
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ~/.jupyter/jupyter.key \
    -out ~/.jupyter/jupyter.pem \
    -subj "/C=BR/ST=State/L=City/O=Organization/CN=localhost"

# Configure Jupyter
cat > ~/.jupyter/jupyter_server_config.py << EOF
import os
from jupyter_server.auth import passwd

c = get_config()

# Basic configuration
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.ServerApp.root_dir = '/home/${USER}/llm-dev/notebooks'
c.ServerApp.allow_origin = '*'
c.ServerApp.allow_remote_access = True

# Security
c.ServerApp.certfile = os.path.expanduser('~/.jupyter/jupyter.pem')
c.ServerApp.keyfile = os.path.expanduser('~/.jupyter/jupyter.key')
c.ServerApp.password = passwd('${JUPYTER_PASSWORD:-changeme}')

# Interface customization
c.ServerApp.terminado_settings = {'shell_command': ['/bin/bash']}

# Resource usage
c.ServerApp.ResourceUseDisplay.mem_limit = '28G'  # Adjust based on your RAM
c.ServerApp.ResourceUseDisplay.track_cpu_percent = True

# Extensions
c.ServerApp.nbserver_extensions = {
    'jupyter_server_proxy': True
}
EOF

# Create systemd service for Jupyter
sudo tee /etc/systemd/system/jupyter.service << EOF
[Unit]
Description=Jupyter Server
After=network.target

[Service]
Type=simple
User=${USER}
Environment="PATH=/home/${USER}/llm-dev/.venv/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=/home/${USER}/llm-dev/.venv/bin/jupyter lab
WorkingDirectory=/home/${USER}/llm-dev/notebooks
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Create notebooks directory structure
mkdir -p ~/llm-dev/notebooks/{examples,models,data,utils}

# Install additional Jupyter extensions
pip install \
    jupyter-server-proxy \
    jupyterlab-git \
    jupyterlab-drawio \
    jupyterlab-execute-time \
    jupyterlab-system-monitor \
    jupyter-resource-usage \
    ipywidgets

# Create example notebook
cat > ~/llm-dev/notebooks/examples/welcome.ipynb << EOF
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Welcome to LLM Development Environment\n",
    "\n",
    "This notebook demonstrates the basic setup and GPU availability."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "source": [
    "import torch\n",
    "import sys\n",
    "import platform\n",
    "\n",
    "print(f'Python version: {sys.version}')\n",
    "print(f'PyTorch version: {torch.__version__}')\n",
    "print(f'CUDA available: {torch.cuda.is_available()}')\n",
    "if torch.cuda.is_available():\n",
    "    print(f'CUDA device: {torch.cuda.get_device_name(0)}')"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  }
 }
}
EOF

# Enable and start Jupyter service
sudo systemctl daemon-reload
sudo systemctl enable jupyter
sudo systemctl start jupyter

# Configure firewall
sudo ufw allow 8888/tcp

echo "Jupyter setup complete!"
