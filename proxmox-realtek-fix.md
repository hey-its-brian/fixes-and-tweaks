# Proxmox Realtek NIC Fix (RTL8111/8168/8411)

Some Proxmox installations (e.g., mini-PCs like Geekom or older Mac Minis) ship with Realtek NICs.  
By default, Linux uses the `r8169` driver for these NICs, which is **buggy and slow**.  
You may see transfer speeds capped at ~2–3 MB/s with `scp` or `rsync`.  

This guide shows how to switch to the proper `r8168` driver on Proxmox VE 8.

---

## 1. Enable the No-Subscription Repo

`nano /etc/apt/sources.list.d/pve-no-subscription.list`

Add:
`deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription`

## 2. Disable the Enterprise Repo
`nano /etc/apt/sources.list.d/pve-enterprise.list`
Comment out the line:
`# deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise`
(Optional) Do the same in `/etc/apt/sources.list.d/ceph.list` if present.

## 3. Update System and Install New Kernel
`apt update
apt dist-upgrade`

Confirm installed kernels:
`dpkg --list | grep pve-kernel`

Reboot into the newest kernel:
`reboot`

After reboot:
`uname -r`
You should see 6.8.x-pve or 5.15.x-pve.

## 4. Install Headers and Realtek Driver
`apt install pve-headers-$(uname -r)
apt install dkms r8168-dkms`

Reboot again.

## 5. Confirm Driver in Use
`lspci -k | grep -A3 Ethernet`

Expected output:
`Kernel driver in use: r8168`

✅ Results

Transfer speeds jump from ~2 MB/s → ~100 MB/s (full gigabit).
System stability improves (no random lockups caused by the buggy r8169 driver).

### Notes
You can still boot into the old kernel from GRUB if something breaks.
The r8168 module will auto-rebuild after kernel updates (thanks to DKMS).
Works with Proxmox VE 8 (Debian 12 bookworm).








