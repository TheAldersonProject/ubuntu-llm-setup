#!/bin/bash
# scripts/utils/monitor-temps.sh
while true; do
    clear
    echo "=== CPU Temperature ==="
    sensors | grep "Core"
    echo -e "\n=== GPU Temperature ==="
    nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader
    echo -e "\n=== Fan Speed ==="
    sensors | grep "fan"
    sleep 2
done
