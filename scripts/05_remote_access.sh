#!/bin/bash
# scripts/05_remote_access.sh
set -e

echo "Installing X server and remote access tools..."
apt install -y \
    xorg \
    xfce4 \
    xfce4-goodies \
    slim \
    xrdp \
    tigervnc-standalone-server \
    tigervnc-common \
    firefox \
    visual-studio-code \
    copyq \
    guake

# Configure VNC
mkdir -p ~/.vnc
cp config/vnc/xstartup ~/.vnc/
chmod +x ~/.vnc/xstartup

# Configure XRDP
cp config/xrdp/xrdp.ini /etc/xrdp/

# Configure services
cp services/vncserver@.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable vncserver@1
systemctl start vncserver@1

# Configure firewall
ufw allow 5901/tcp  # VNC
ufw allow 3389/tcp  # RDP

echo "Remote access setup complete!"
