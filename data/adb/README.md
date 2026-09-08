# Android-Tethered Homelab Network Bridge

## Network Topology Summary
* Home Wi-Fi Subnet: 192.168.1.0/24
* USB Tether Subnet: 192.168.224.0/24 

## Key Device IP Addresses & Variables
* Default Gateway IP Address: 192.168.1.1
* Android Phone (Wi-Fi / Gateway): 192.168.1.2 
* Android Phone (USB Gateway): 192.168.224.126 
* Linux Homelab (USB Interface): 192.168.224.90 

## Step-by-Step Configuration & Command Reference
### Step A: Android Phone Setup (Magisk Persistent Root Script)
Initialization script to make IP forwarding, NAT masquerading, and firewall rules survive reboots

```
cat << 'EOF' > /data/adb/service.sh
#!/system/bin/sh
sleep 5
sysctl -w net.ipv4.ip_forward=1
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -i usb0 -o wlan0 -j ACCEPT
iptables -A FORWARD -i wlan0 -o usb0 -j ACCEPT
EOF
```
```
chmod 755 /data/adb/service.sh
```

### Step B: Linux Homelab Setup (Static IP & Default Gateway)
Set USB network interface to fixed static IP (192.168.224.90) with the phone's USB IP (192.168.224.126) as its gateway.
Because the phone is configured as the default gateway, traffic to the home network automatically routes through the phone without needing custom route commands.

Verification commands on homelab:
```
ip a
ip route
```

### Step C: Home Wi-Fi Router Setup (Network-Wide Static Route)
Instead of configuring individual client devices (like Mac or iPhone), add a static route on the router so all Wi-Fi devices can reach the homelab.

#### Router Admin Panel Settings:
* Destination Network: 192.168.224.0 
* Subnet Mask: 255.255.255.0 
* Gateway / Next Hop: 192.168.0.2 (Phone's current Wi-Fi IP)

## Troubleshooting & Testing Commands
```
# Test connection from client to homelab: 
ping 192.168.224.90   
# Check phone iptables forward rules 
iptables -L FORWARD -v -n   
# Check if IP forwarding is active on the phone (Should output: 1)
  cat /proc/sys/net/ipv4/ip_forward
```
