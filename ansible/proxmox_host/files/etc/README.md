## 1. Hardware & Driver Details

* **Device:** TP-Link TL-WN821N v3 / TL-WN822N v2 (802.11n)
* **USB ID:** `0cf3:7015 Qualcomm Atheros Communications`
* **Chipset:** Atheros AR7010 + AR9287
* **Kernel Driver Module:** `ath9k_htc`
* **Status:** Fully supported out-of-the-box by the default Proxmox/Debian kernel. No proprietary out-of-tree drivers or non-free repository firmware packages are needed.

---

## 2. Prerequisites & Required Tools

Only the base networking utilities need to be present (most are preinstalled on Proxmox VE):

## 3. Tree

```
.
├── README.md
├── etc/
│   ├── hosts                           # Mandatory node hostname-to-IP resolution for PVE services
│   ├── network/
│   │   └── interfaces                  # Core network topology (wlan0, nic0, vmbr0, NAT & DNAT)
│   ├── resolv.conf                     # Upstream DNS configuration
│   ├── sysctl.d/
│   │   └── 99-networking.conf          # Persistent kernel IP forwarding (net.ipv4.ip_forward = 1)
│   ├── systemd/
│   │   └── network/
│   │       └── 10-wlan0.link           # Predictable interface naming binding MAC to wlan0
│   └── wpa_supplicant/
│       └── wpa_supplicant.conf         # Wi-Fi SSID and PSK (keep private or use hashed PSK)
```

## 4. Network Topology Overview

```
[ Home LAN: 192.168.0.0/24 ]
           │
           ├── Router Gateway: 192.168.0.1
           │
           ▼
[ Proxmox Host: homelab.local ]
  ├── wlan0: 192.168.0.100/24 (Metric 100 - Primary Link via ath9k_htc)
  ├── nic0:  DHCP (Metric 200 - Hotplug Fallback Ethernet)
  │
  ├── [ IPv4 Forwarding & iptables NAT Engine ]
  │     ├── MASQUERADE (Outbound internet access for guests)
  │     └── PREROUTING DNAT (Inbound port forwarding to specific VMs)
  │
  └── vmbr0: 10.10.10.1/24 (bridge-ports none - Internal Virtual Router)
        │
        ▼
  [ Internal Guest Network: 10.10.10.0/24 ]
        ├── VM 10.10.10.5 (e.g., qBittorrent Web UI: 8080, Torrent Listen: 6881)
        └── Other LXC/VM instances
```
