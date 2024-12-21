# Makefile
.PHONY: all system nvidia docker python remote power monitoring clean

all: system nvidia docker python remote power monitoring

help:
	@echo "Ubuntu LLM Development Environment Setup"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@echo "Installation:"
	@echo "  install     - Full system installation (recommended)"
	@echo ""
	@echo "Individual Components:"
	@echo "  cleanup     - Remove unnecessary packages and services"
	@echo "  system      - Set up base system configuration"
	@echo "  nvidia      - Install and configure NVIDIA drivers"
	@echo "  docker      - Set up Docker with NVIDIA support"
	@echo "  python      - Configure Python development environment"
	@echo "  remote      - Set up remote access (VNC/RDP)"
	@echo "  power       - Configure power management"
	@echo "  monitoring  - Set up system monitoring"
	@echo "  jupyter     - Configure Jupyter Lab environment"
	@echo "  ssh         - Set up SSH server with X11 forwarding"
	@echo ""
	@echo "Maintenance:"
	@echo "  clean       - Remove temporary files"
	@echo "  test        - Test the installation"
	@echo ""
	@echo "Usage:"
	@echo "  sudo make [target]"
	@echo ""
	@echo "Example:"
	@echo "  sudo make install    # Full installation"
	@echo "  sudo make nvidia     # Only NVIDIA setup"
	@echo ""
	@echo "Note: Most targets require root privileges"

# Make help the default target
.DEFAULT_GOAL := help

check-root:
	@if [ $$(id -u) -ne 0 ]; then echo "Please run as root" && exit 1; fi

system: check-root
	@echo "Setting up base system..."
	@bash scripts/01_system_base.sh

nvidia: check-root
	@echo "Setting up NVIDIA drivers..."
	@bash scripts/02_nvidia_setup.sh

docker: check-root
	@echo "Setting up Docker..."
	@bash scripts/03_docker_setup.sh

python: check-root
	@echo "Setting up Python environment..."
	@bash scripts/04_python_setup.sh

remote: check-root
	@echo "Setting up remote access..."
	@bash scripts/05_remote_access.sh

power: check-root
	@echo "Setting up power management..."
	@bash scripts/06_power_management.sh

monitoring: check-root
	@echo "Setting up monitoring..."
	@bash scripts/07_monitoring.sh

clean:
	@echo "Cleaning temporary files..."
	rm -rf /tmp/ubuntu-llm-setup-*

test:
	@echo "Testing installation..."
	@bash scripts/utils/check-system.sh

cleanup: check-root
	@echo "Cleaning up unnecessary packages and services..."
	@bash scripts/00_cleanup.sh

jupyter: check-root
	@echo "Setting up Jupyter environment..."
	@bash scripts/08_jupyter_setup.sh

ssh: check-root
	@echo "Setting up SSH server..."
	@bash scripts/09_ssh_setup.sh

install: cleanup system nvidia docker python remote power monitoring jupyter ssh
	@echo "Installation complete!"
	@echo "Please reboot your system."
