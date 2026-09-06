#!/system/bin/sh

# Wait for network interfaces to initialize
sleep 5

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Set default firewall policies and NAT
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

# Allow forwarding traffic between USB and Wi-Fi
iptables -A FORWARD -i usb0 -o wlan0 -j ACCEPT
iptables -A FORWARD -i wlan0 -o usb0 -j ACCEPT
