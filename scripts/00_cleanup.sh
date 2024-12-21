#!/bin/bash
# scripts/00_cleanup.sh
set -e

echo "Starting Ubuntu cleanup..."

# List of services to disable
SERVICES_TO_DISABLE=(
    "cups.service"
    "ModemManager.service"
    "avahi-daemon.service"
    "speech-dispatcher.service"
)

# List of packages to remove
PACKAGES_TO_REMOVE=(
    # Unnecessary system packages
    "snapd"
    "ubuntu-advantage-tools"
    "popularity-contest"
    "apport"
    "whoopsie"

    # Printer services
    "cups"
    "cups-browsed"
    "cups-daemon"

    # Desktop packages (if not needed)
    "gnome-games"
    "aisleriot"
    "gnome-mahjongg"
    "gnome-mines"
    "gnome-sudoku"

    # Office suite (if not needed)
    "libreoffice-*"

    # Audio packages (if not needed)
    "pulseaudio"

    # Other unnecessary packages
    "thunderbird"
    "transmission-*"
    "rhythmbox"
    "totem"
    "ubuntu-report"
    "update-manager"
    "update-notifier"
)

# Disable unnecessary services
echo "Disabling unnecessary services..."
for service in "${SERVICES_TO_DISABLE[@]}"; do
    if systemctl is-active --quiet "$service"; then
        systemctl stop "$service"
        systemctl disable "$service"
        echo "Disabled $service"
    fi
done

# Remove snap packages
echo "Removing snap packages..."
snap list | awk 'NR>1 {print $1}' | while read -r snapname; do
    snap remove "$snapname"
done

# Remove snapd completely
apt purge -y snapd

# Remove unnecessary packages
echo "Removing unnecessary packages..."
apt purge -y "${PACKAGES_TO_REMOVE[@]}"

# Clean up package cache
echo "Cleaning package cache..."
apt autoremove -y
apt clean
apt autoclean

# Clean up system logs
echo "Cleaning system logs..."
journalctl --vacuum-time=1d

# Clean up user cache
echo "Cleaning user cache..."
rm -rf /home/*/.cache/*
rm -rf /root/.cache/*

# Clean up temporary files
echo "Cleaning temporary files..."
rm -rf /tmp/*
rm -rf /var/tmp/*

# Clean up old kernels
echo "Cleaning old kernels..."
dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs apt purge -y

# Remove unnecessary directories
echo "Removing unnecessary directories..."
rm -rf /usr/share/doc/*
rm -rf /usr/share/man/*
rm -rf /usr/share/locale/*
rm -rf /var/cache/apt/archives/*

# Disable unnecessary kernel modules
echo "Configuring kernel modules..."
cat > /etc/modprobe.d/blacklist-unnecessary.conf << EOF
# Disable unused network protocols
blacklist dccp
blacklist sctp
blacklist rds
blacklist tipc

# Disable unused file systems
blacklist cramfs
blacklist freevxfs
blacklist jffs2
blacklist hfs
blacklist hfsplus
blacklist squashfs

# Disable unused drivers
EOF

# Update GRUB to remove unnecessary options
echo "Updating GRUB configuration..."
sed -i 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=2/' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet nosplash noresume"/' /etc/default/grub
update-grub

# Optimize systemd services
echo "Optimizing systemd services..."
systemctl mask systemd-udev-settle.service
systemctl mask systemd-networkd-wait-online.service
systemctl mask NetworkManager-wait-online.service

# Create cleanup cronjob
echo "Setting up automatic cleanup..."
cat > /etc/cron.weekly/system-cleanup << EOF
#!/bin/bash
apt autoremove -y
apt clean
journalctl --vacuum-time=1d
rm -rf /tmp/*
rm -rf /var/tmp/*
EOF
chmod +x /etc/cron.weekly/system-cleanup

echo "System cleanup complete!"
