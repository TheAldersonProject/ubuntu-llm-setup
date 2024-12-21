# Ubuntu LLM Development Environment Setup

This repository contains scripts and configurations for setting up an Ubuntu-based LLM development environment on a Lenovo Legion Y540-15irh.

## Hardware Specifications
- CPU: Intel Core i7-9750H (6 cores, 12 threads)
- GPU: NVIDIA GeForce RTX 2060 (6GB GDDR6)
- RAM: 32GB DDR4-2666
- Chipset: Intel HM370

## Installation
1.  Clone this repository:
```bash
    git clone https://github.com/TheAldersonProject/ubuntu-llm-setup.git
    cd ubuntu-llm-setup
```

2. Run the installation:
```bash 
  sudo make install
```

## Individual Components
You can install individual components using:
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

## Monitoring
Access Grafana dashboard at http://localhost:3000

## Remote Access
* VNC: Connect to vnc://your_server_ip:5901
* RDP: Use Microsoft Remote Desktop to connect to your server IP

## License: 
MIT
