#!/bin/bash
# scripts/utils/check-system.sh
echo "=== System Status ==="
echo "Lid Status: $(cat /proc/acpi/button/lid/LID0/state)"
echo "Power Status: $(cat /sys/class/power_supply/AC*/online)"
echo "CPU Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
echo -e "\n=== Temperatures ==="
sensors
echo -e "\n=== GPU Status ==="
nvidia-smi
