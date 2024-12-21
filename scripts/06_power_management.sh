#!/bin/bash
# scripts/06_power_management.sh
set -e

echo "Installing power management tools..."
apt install -y \
    tlp \
    tlp-rdw \
    powertop \
    thermald

# Copy configurations
cp config/tlp/tlp.conf /etc/tlp.conf
cp config/system/logind.conf /etc/systemd/logind.conf

# Copy and setup thermal protection
cp scripts/utils/thermal-protection.sh /usr/local/bin/
chmod +x /usr/local/bin/thermal-protection.sh
cp services/thermal-protection.service /etc/systemd/system/

# Enable services
systemctl enable tlp
systemctl start tlp
systemctl enable thermald
systemctl start thermald
systemctl enable thermal-protection
systemctl start thermal-protection

echo "Power management setup complete!"
