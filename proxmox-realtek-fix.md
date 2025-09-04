# Proxmox Realtek NIC Fix (RTL8111/8168/8411)

Some Proxmox installations (e.g., mini-PCs like Geekom or older Mac Minis) ship with Realtek NICs.  
By default, Linux uses the `r8169` driver for these NICs, which is **buggy and slow**.  
You may see transfer speeds capped at ~2–3 MB/s with `scp` or `rsync`.  

This guide shows how to switch to the proper `r8168` driver on Proxmox VE 8.

---

## 1. Enable the No-Subscription Repo

nano /etc/apt/sources.list.d/pve-no-subscription.list

Add:
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
Save, exit, reboot
