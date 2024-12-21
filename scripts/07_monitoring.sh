#!/bin/bash
# scripts/07_monitoring.sh
set -e

echo "Installing monitoring tools..."
apt install -y \
    prometheus \
    prometheus-node-exporter \
    grafana

# Copy monitoring scripts
cp scripts/utils/monitor-temps.sh /usr/local/bin/
cp scripts/utils/check-system.sh /usr/local/bin/
chmod +x /usr/local/bin/monitor-temps.sh
chmod +x /usr/local/bin/check-system.sh

# Enable services
systemctl enable prometheus
systemctl start prometheus
systemctl enable grafana-server
systemctl start grafana-server

echo "Monitoring setup complete!"
