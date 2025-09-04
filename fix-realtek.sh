#!/bin/bash
# fix-realtek.sh
# Automates switching Proxmox from r8169 → r8168 driver
# Tested on Proxmox VE 8 (Debian 12 / bookworm)

set -e

echo "=== Proxmox Realtek NIC Fix Script ==="

# 1. Enable no-subscription repo
echo ">> Adding no-subscription repo..."
cat <<EOF >/etc/apt/sources.list.d/pve-no-subscription.list
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
EOF

# 2. Disable enterprise repos if present
if [ -f /etc/apt/sources.list.d/pve-enterprise.list ]; then
    echo ">> Disabling enterprise repo..."
    sed -i 's|^deb https://enterprise.proxmox.com|# deb https://enterprise.proxmox.com|' /etc/apt/sources.list.d/pve-enterprise.list
fi

if [ -f /etc/apt/sources.list.d/ceph.list ]; then
    echo ">> Disabling ceph enterprise repo..."
    sed -i 's|^deb https://enterprise.proxmox.com|# deb https://enterprise.proxmox.com|' /etc/apt/sources.list.d/ceph.list
fi

# 3. Update system and install latest kernel
echo ">> Updating system..."
apt update
apt -y dist-upgrade

# 4. Install headers + r8168 driver
KERNEL_VERSION=$(uname -r)
echo ">> Installing headers for $KERNEL_VERSION ..."
apt -y install "pve-headers-$KERNEL_VERSION" || {
    echo "Headers for current kernel not found. Try rebooting into the new kernel and rerun this script."
    exit 1
}

echo ">> Installing DKMS + r8168 driver..."
apt -y install dkms r8168-dkms

echo "=== Done! Please reboot to activate the new kernel and driver. ==="
