# scripts/09_ssh_setup.sh
#!/bin/bash
set -e

echo "Configuring SSH server..."

# Install SSH server if not present
apt install -y openssh-server

# Backup original SSH config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Configure SSH server
cat > /etc/ssh/sshd_config << EOF
# Basic SSH Configuration
Port 22
AddressFamily any
ListenAddress 0.0.0.0

# Security
Protocol 2
PermitRootLogin no
PasswordAuthentication yes  # Will disable after key setup
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PermitEmptyPasswords no
MaxAuthTries 3

# Performance and Security
UseDNS no
TCPKeepAlive yes
ClientAliveInterval 60
ClientAliveCountMax 3
MaxStartups 10:30:60
LoginGraceTime 30

# Features
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalhost no
AllowTcpForwarding yes
AllowAgentForwarding yes

# Strict Mode and Usage
StrictModes yes
MaxSessions 10

# Logging
SyslogFacility AUTH
LogLevel VERBOSE

# Environment
AcceptEnv LANG LC_*
EOF

# Create SSH directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate host keys if they don't exist
ssh-keygen -A

# Configure SSH client
cat > ~/.ssh/config << EOF
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    StrictHostKeyChecking ask
    VerifyHostKeyDNS yes
    ForwardAgent no
    ForwardX11 yes
    ForwardX11Trusted yes
    HashKnownHosts yes
    PasswordAuthentication yes
    HostbasedAuthentication no
EOF

chmod 600 ~/.ssh/config

# Add to UFW
ufw allow ssh

# Create SSH key management script
cat > /usr/local/bin/ssh-manager << EOF
#!/bin/bash

function generate_key() {
    ssh-keygen -t ed25519 -C "\$USER@\$(hostname)-\$(date +%Y%m%d)"
}

function add_key() {
    if [ -z "\$1" ]; then
        echo "Please provide the public key"
        return 1
    fi
    echo "\$1" >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
}

function list_keys() {
    if [ -f ~/.ssh/authorized_keys ]; then
        echo "Authorized keys:"
        cat ~/.ssh/authorized_keys
    else
        echo "No authorized keys found"
    fi
}

function remove_key() {
    if [ -z "\$1" ]; then
        echo "Please provide the line number of the key to remove"
        return 1
    fi
    sed -i "\$1d" ~/.ssh/authorized_keys
}

function disable_password_auth() {
    sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    echo "Password authentication disabled"
}

function help() {
    echo "SSH Key Manager"
    echo "Usage: ssh-manager [command]"
    echo ""
    echo "Commands:"
    echo "  generate    Generate new SSH key pair"
    echo "  add        Add public key to authorized_keys"
    echo "  list       List authorized keys"
    echo "  remove     Remove key by line number"
    echo "  disable    Disable password authentication"
    echo "  help       Show this help message"
}

case "\$1" in
    generate)
        generate_key
        ;;
    add)
        add_key "\$2"
        ;;
    list)
        list_keys
        ;;
    remove)
        remove_key "\$2"
        ;;
    disable)
        disable_password_auth
        ;;
    *)
        help
        ;;
esac
EOF

chmod +x /usr/local/bin/ssh-manager

# Start and enable SSH service
systemctl enable ssh
systemctl start ssh

echo "SSH server configuration complete!"
echo "Use 'ssh-manager' to manage SSH keys"
