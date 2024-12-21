# Makefile
.PHONY: all system nvidia docker python remote power monitoring clean

all: system nvidia docker python remote power monitoring

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

install: all
	@echo "Installation complete!"
	@echo "Please reboot your system."

test:
	@echo "Testing installation..."
	@bash scripts/utils/check-system.sh
