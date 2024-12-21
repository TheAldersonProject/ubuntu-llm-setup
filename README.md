# Ubuntu LLM Development Environment Setup

This repository contains scripts and configurations for setting up an Ubuntu-based LLM development environment on a Lenovo Legion Y540-15irh.

## Hardware Specifications
- CPU: Intel Core i7-9750H (6 cores, 12 threads)
- GPU: NVIDIA GeForce RTX 2060 (6GB GDDR6)
- RAM: 32GB DDR4-2666
- Chipset: Intel HM370

## Features
- 🧹 Optimized Ubuntu installation with unnecessary packages removed
- 🚀 NVIDIA drivers and CUDA setup for ML/AI development
- 🐋 Docker with NVIDIA container runtime
- 🐍 Python 3.12 environment with ML packages
- 🔗 Remote access via VNC and RDP
- 💪 Power management optimized for closed-lid operation
- 📊 System monitoring with Prometheus and Grafana
- 🛡️ Thermal protection system

## Prerequisites
- Ubuntu Server 22.04 LTS (fresh installation)
- Internet connection
- Sudo privileges

## Installation
1.  Clone this repository:
```bash
    git clone https://github.com/TheAldersonProject/ubuntu-llm-setup.git
    cd ubuntu-llm-setup
```

2. Full installation:
```bash 
  sudo make install
```

## SSH Access

### Connection
```bash
ssh username@your_server_ip
```

### Security Features
- SSH Protocol 2 only
- Root login disabled
- Strict access controls
- X11 forwarding enabled
- Regular security updates

### Managing SSH Keys
1.	Generate new key:
```bash
  ssh-manager generate
```

2. Add public key:
```bash
  ssh-manager add "ssh-ed25519 AAAA..."
```

3. List authorized keys:
```bash
  ssh-manager list
```

4.	Remove key:
```bash
    ssh-manager list  # Note the line number
    ssh-manager remove 2  # Remove second key
````

### From MacBook

1.	Generate key on MacBook:
```bash
  ssh-keygen -t ed25519 -C "your_email@example.com"
```

2.	Copy key to server:
```bash
  ssh-copy-id username@your_server_ip
```

3.	Create SSH config on MacBook:
```bash
    cat >> ~/.ssh/config << EOF
    Host llm-server
        HostName your_server_ip
        User your_username
        Port 22
        IdentityFile ~/.ssh/id_ed25519
        ForwardX11 yes
        ForwardX11Trusted yes
    EOF
```

4.	Connect using config:
```bash
  ssh llm-server
```

## Individual Components
You can install individual components using:
* sudo make cleanup - Remove unnecessary packages and services
* sudo make system - Base system setup
* sudo make nvidia - NVIDIA drivers and CUDA
* sudo make docker - Docker and containers
* sudo make python - Python development environment
* sudo make remote - Remote access (VNC/XRDP)
* sudo make power - Power management
* sudo make monitoring - System monitoring

## Testing
To test the installation:

```bash
    sudo make test
```
## Post-Installation

### Remote Access
- VNC: Connect to vnc://your_server_ip:5901
- RDP: Use Microsoft Remote Desktop to connect to your server IP
- Default VNC password will be set during installation

### Monitoring
- Access Grafana dashboard at http://localhost:3000
- System monitoring script: monitor-temps.sh
- System status check: check-system.sh

### Docker
```bash
    # Test NVIDIA Docker
    docker run --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi
```

## System Maintenance
### Automatic Cleanup
- Weekly cleanup job installed
- Cleans temporary files
- Removes old logs
- Updates package cache

### Manual Cleanup
```bash 
    sudo make cleanup
```
### Temperature Monitoring
```bash
  monitor-temps.sh
```

### System Check
```bash
  check-system.sh
```

## Closed Lid Operation
### The system is configured to:
- Continue running with lid closed
- Monitor temperatures
- Automatically shutdown if temperature thresholds are exceeded
- Maintain network connections
- Keep remote access available

## Security Considerations
1.	Remote Access
- Change default VNC password
- Configure UFW firewall
- Set up SSH keys
- Disable password authentication for SSH

2. System Updates
- Regular security updates enabled
- Automatic cleanup of old packages
- Monitoring for system issues

## Troubleshooting
### Common Issues
1. GPU Not Detected
```bash 
    nvidia-smi
    # Check driver installation status
    sudo ubuntu-drivers devices
```
2. Remote Access Issues
```bash 
    # Restart services
    sudo systemctl restart vncserver@1
    sudo systemctl restart xrdp
```
	
4. Temperature Issues
```bash
    # Check current temperatures
    check-system.sh
    # View thermal protection status
    sudo systemctl status thermal-protection
```

## Performance Tuning
### The installation includes optimized configurations for:
- CPU governor settings
- NVIDIA power management
- Memory management
- Docker performance
- System services

## Jupyter Lab Environment

### Access Jupyter Lab
- Available at: https://your_server_ip:8888
- Default password: changeme (change this immediately!)

### Directory Structure
```
~/llm-dev/notebooks/
├── examples/      # Example notebooks
├── models/        # Model development
├── data/          # Dataset storage
└── utils/         # Utility functions
```


### Managing Jupyter

#### Start/Stop/Restart:
```bash
    jupyter-manager start
    jupyter-manager stop
    jupyter-manager restart
```
#### Change Password:
```bash 
    jupyter-manager password
```

#### View Logs:
```bash
  jupyter-manager logs
```

#### Example Usage
1. Start Jupyter:
```bash
  jupyter-manager start
```
2. Access via browser:
```
    https://your_server_ip:8888
```
3. Open `examples/welcome.ipynb` to verify setup

#### Resource Management
- Memory limit: 28GB (configurable)
- CPU usage tracking enabled
- GPU metrics available
