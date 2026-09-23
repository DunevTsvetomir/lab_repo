#!/usr/bin/env bash
set -euo pipefail

# --- Enable IP forwarding permanently ---
cat > /etc/sysctl.d/99-ipforward.conf <<'EOF'
net.ipv4.ip_forward = 1
EOF
sysctl --system >/dev/null

# --- Find the WAN interface (the one with the default route, i.e. the
#     VirtualBox NAT adapter that Vagrant uses for management) ---
WAN_IF=$(ip route show default | awk '{print $5}' | head -n1)
echo "Detected WAN interface: ${WAN_IF}" > /etc/wan-interface

# --- NAT/MASQUERADE so LAN1 + LAN2 can reach the internet through gw ---
iptables -t nat -C POSTROUTING -o "${WAN_IF}" -j MASQUERADE 2>/dev/null || \
  iptables -t nat -A POSTROUTING -o "${WAN_IF}" -j MASQUERADE

iptables -C FORWARD -i "${WAN_IF}" -o "${WAN_IF}" -j ACCEPT 2>/dev/null || true
iptables -C FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || \
  iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -C FORWARD -s 192.168.10.0/24 -j ACCEPT 2>/dev/null || \
  iptables -A FORWARD -s 192.168.10.0/24 -j ACCEPT
iptables -C FORWARD -s 192.168.20.0/24 -j ACCEPT 2>/dev/null || \
  iptables -A FORWARD -s 192.168.20.0/24 -j ACCEPT

# Persist the rules across reboots/vagrant reload
netfilter-persistent save >/dev/null 2>&1 || true

echo ""
echo "=== gw ready ==="
echo "WAN (internet):  ${WAN_IF}"
echo "LAN1:            192.168.10.1/24"
echo "LAN2:            192.168.20.1/24"
