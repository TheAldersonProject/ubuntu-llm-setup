#!/bin/bash
# scripts/utils/thermal-protection.sh
while true; do
    CPU_TEMP=$(sensors | grep "Package id 0:" | cut -d'+' -f2 | cut -d'.' -f1)
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)

    if [ $CPU_TEMP -gt 95 ] || [ $GPU_TEMP -gt 87 ]; then
        logger "Emergency thermal shutdown triggered: CPU=$CPU_TEMP°C GPU=$GPU_TEMP°C"
        shutdown -h now
    fi
    sleep 30
done
